*----------------------------------------------------------------------*
* Program name : ZQTCR_MED_ISS_R115_SUB (Inclde program)               *
* REVISION NO : ED2K921929/ED2K922697/ED2K922788/ED2K922941            *
* REFERENCE NO: OTCM-29592                                             *
* DEVELOPER   : Lahiru Wathudura (LWATHUDURA)                          *
* DATE        : 02/16/2021 , 03/24/2021                                *
* DESCRIPTION : Media Issue cockpit dashboard additional fields enhancement
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K925006                                             *
* REFERENCE NO: OTCM-45347                                             *
* DEVELOPER   : Thilina Dimantha (TDIMANTHA)                           *
* DATE        : 11/12/2021                                             *
* DESCRIPTION : Media Issue cockpit Performence improvement
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data.

  IF rb1 IS NOT INITIAL.
    c_exbb = 'YES'.
  ELSE.
    c_exbb = 'NO'.
  ENDIF.
  IF rb3 IS NOT INITIAL.
    c_exdb = 'YES'.
  ELSE.
    c_exdb = 'NO'.
  ENDIF.
  IF rb5 IS NOT INITIAL.
    c_excb = 'YES'.
  ELSE.
    c_excb = 'NO'.
  ENDIF.
  IF rb7 IS NOT INITIAL.
    c_excc = 'YES'.
  ELSE.
    c_excc = 'NO'.
  ENDIF.
  IF rb9 IS NOT INITIAL.
    c_exro = 'YES'.
  ELSE.
    c_exro = 'NO'.
  ENDIF.
  IF rb11 IS NOT INITIAL.
    c_irel = 'YES'.
  ELSE.
    c_irel = 'NO'.
  ENDIF.
  IF rbg1 IS NOT INITIAL.
    c_iamt = 'YES'.
  ELSE.
    c_iamt = 'NO'.
  ENDIF.

  REFRESH: i_issue[],i_contract[], i_podata[],
           i_alv_output[], i_count[], i_contract_data[],
           i_claim_orders[], i_dup_orders[].
  CLEAR: v_count.
* BOC ED2K925042 22-Nov-2021 TDIMANTHA
*  IF cb_rar IS NOT INITIAL.
*
*    SELECT contract,
*           item,
*           media_issue,
*           journal,
*           rar_relevant,
*           price_grp,
*           price_grp_desc
*      FROM zcds_mip_006
*      INTO TABLE @i_issue
*      WHERE contract IN @s_sdoc
*      AND   media_issue IN @s_issu
*      AND   journal IN @s_prod.
*
*    IF i_issue[] IS NOT INITIAL.
*      SORT i_issue.
*      DELETE ADJACENT DUPLICATES FROM i_issue COMPARING ALL FIELDS.
*      SELECT  contract,
*              item,
*              media_issue,
*              journal,
*              contract_start_date,
*              contract_end_date,
*              acceptance_date,
*              req_cancellation_date,
*              item_category,
*              cancel_reason,
*              cancel_reason_desc,
*              reason_for_cancel,
*              cancelled_orders,
*              overall_doc_status,
*              overall_status_desc,
*              credit_status,
*              credit_status_desc,
*              contract_qty,
*              plant,
*              mat_grp_5_code,
*              mat_grp_5,
*              mat_grp_3_code,
*              mat_grp_3,
*              net_value_item,
*              currency,
*              credit_block_flag,
*              cancel_res_flag,
*              reason_for_cancel_desc,
*              cancelled_orders_desc,
*              cancel_ord_flag
*        FROM zcds_mip_005
*        INTO TABLE @i_contract
*        FOR ALL ENTRIES IN @i_issue
*        WHERE contract EQ @i_issue-contract
*        AND   item EQ @i_issue-item
*        AND   media_issue EQ @i_issue-media_issue
*        AND   journal EQ @i_issue-journal
*        AND   contract_start_date IN @s_csdt
*        AND   contract_end_date IN @s_cedt
*        AND   item_category IN @s_itcg
*        AND   credit_block_flag EQ @c_excb
*        AND   cancel_res_flag EQ @c_exro
*        AND   cancel_ord_flag EQ @c_excc.
*
*      SELECT contract,
*              item,
*              media_issue,
*              journal,
*              assignment,
*              publication_date,
*              actual_gi_date,
*              profit_center,
*              material_status,
*              distr_chain_status,
*              issue_number,
*              vol_copy_no,
*              year_number,
*              publication_type,
*              release_order_created,
*              status,
*              plan_status_desc,
*              planned_ro_from,
*              planned_ro_to,
*              release_order,
*              release_order_item,
*              po_number,
*              po_item,
*              po_type,
*              po_del_ind,
*              po_info_rec,
*              po_qty,
*              delivery_number,
*              delivery_item,
*              purchase_requisition,
*              purchase_requisition_item,
*              mat_doc,
*              mat_doc_item,
*              mat_doc_type,
*              mat_doc_year,
*              mat_doc_date,
*              billing_block,
*              billing_block_desc,
*              delivery_block,
*              delivery_block_desc,
*              sales_org,
*              dist_channel,
*              division,
*              doc_type,
*              sales_office,
*              earned_amount,
*              billed_amount,
*              balance,
*              document_currency,
*              contract_reason,
*              del_plant,
*              bill_block_flag,
*              del_block_flag,
*              rel_ord_flag,
*              unearned_flag,
*              vendor,
*              vendor_name,
*              delivery_date,
*              init_ship_date,
*              dist_chain_status,
*              mi_ic_group
*        FROM zcds_mip_004
*        INTO TABLE @i_podata
*        FOR ALL ENTRIES IN @i_issue
*        WHERE contract EQ @i_issue-contract
*        AND   item EQ @i_issue-item
*        AND   media_issue EQ @i_issue-media_issue
*        AND   journal EQ @i_issue-journal
*        AND   publication_date IN @s_pbdt
*        AND   actual_gi_date IN @s_gddt
*        AND   bill_block_flag EQ @c_exbb
*        AND   del_block_flag EQ @c_exdb
*        AND   rel_ord_flag EQ @c_irel
*        AND   unearned_flag EQ @c_iamt
*        AND   init_ship_date IN @s_indt
*        AND   delivery_date IN @s_dldt
*        AND   sales_org IN @s_sorg
*        AND   dist_channel IN @s_dist
*        AND   division IN @s_sdiv
*        AND   sales_office IN @s_soff
*        AND   assignment IN @s_assg
*        AND   doc_type IN @s_dctp
*        AND   release_order IN @s_rele.
*
*      SELECT vbeln,
*             posnr,
*             issue_count,
*             net_value,
*             value_per_issue
*        FROM zcds_mi_r115_2
*        INTO TABLE @i_count
*        FOR ALL ENTRIES IN @i_issue
*        WHERE vbeln EQ @i_issue-contract
*        AND   posnr EQ @i_issue-item.
*
*      SELECT * FROM zcds_con_r115
*        INTO TABLE @i_contract_data
*        FOR ALL ENTRIES IN @i_issue
*        WHERE contract = @i_issue-contract AND
*              item     = @i_issue-item     AND
*              media_issue = @i_issue-media_issue AND
*              journal   = @i_issue-journal.
*      IF sy-subrc IS INITIAL.
*        SORT i_contract_data BY contract
*                                item
*                                journal
*                                media_issue.
*      ENDIF.
*      IF rb11 IS NOT INITIAL. "When Release order details selected
*        SELECT * FROM zcds_claim_r115
*          INTO TABLE @i_claim_orders
*          FOR ALL ENTRIES IN @i_issue
*          WHERE contract       = @i_issue-contract AND
*                contract_item  = @i_issue-item     AND
*                media_issue    = @i_issue-media_issue.
*        IF sy-subrc IS INITIAL.
*          SORT i_claim_orders BY contract
*                                 contract_item
*                                 media_issue.
*        ENDIF.
*
*        SELECT * FROM zcds_clm_dup
*          INTO TABLE @i_dup_orders
*          FOR ALL ENTRIES IN @i_issue
*          WHERE contract      = @i_issue-contract AND
*                contract_item = @i_issue-item     AND
*                media_issue   = @i_issue-media_issue.
*        IF sy-subrc IS INITIAL.
*          SORT i_dup_orders BY contract
*                               contract_item
*                               media_issue.
*        ENDIF.
*      ENDIF.
*      SORT i_contract BY contract
*                         item
*                         journal
*                         media_issue.
*      SORT i_podata BY contract
*                         item
*                         journal
*                         media_issue.
*      SORT i_count BY    vbeln
*                         posnr.
*    ELSE. "IF i_issue[] INITIAL.
*      MESSAGE i000(zren) DISPLAY LIKE 'E'.
*      LEAVE LIST-PROCESSING.
*    ENDIF. "IF i_issue[] IS NOT INITIAL.
*
**  SELECT * FROM zcds_mi_r115_rpt INTO TABLE @i_view
**  WHERE
**    journal IN @s_prod                 "6
**    AND media_issue IN @s_issu         "6
**    AND publication_date IN @s_pbdt    "4
**    AND init_ship_date IN @s_indt      "4
**    AND delivery_date IN @s_dldt       "4
**    AND actual_gi_date IN @s_gddt      "4
**    AND sales_org IN @s_sorg           "4
**    AND dist_channel IN @s_dist        "4
**    AND division IN @s_sdiv            "4
**    AND sales_office IN @s_soff        "4
**    AND contract IN @s_sdoc            "6
**    AND assignment IN @s_assg          "4
**    AND doc_type IN @s_dctp            "4
**    AND item_category IN @s_itcg       "5
**    AND contract_start_date IN @s_csdt "5
**    AND contract_end_date IN @s_cedt   "5
**    AND release_order IN @s_rele       "4
**    AND bill_block_flag EQ @c_exbb     "4
**    AND del_block_flag EQ @c_exdb      "4
**    AND credit_block_flag EQ @c_excb   "5
**    AND cancel_ord_flag EQ @c_excc     "5
**    AND cancel_res_flag EQ @c_exro     "5
**    AND rel_ord_flag EQ @c_irel        "4
**    AND unearned_flag EQ @c_iamt.      "4
****
****    AND ( ( ( contract_start_date GE @s_vdat-low AND contract_end_date LE @s_vdat-high )
****              OR  ( contract_end_date GE @s_vdat-low AND contract_start_date LE @s_vdat-high ) ) ).
****  "AND ( contract_start_date GE @s_cdat-low AND contract_end_date LE @s_cdat-high ).
**
**
**  IF sy-subrc = 0.
**    SORT i_view.
**    DELETE ADJACENT DUPLICATES FROM i_view COMPARING ALL FIELDS.
**
*** BOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
**    SELECT * FROM zcds_con_r115
**      INTO TABLE @i_contract_data
**      FOR ALL ENTRIES IN @i_view
**      WHERE contract = @i_view-contract AND
**            item     = @i_view-item     AND
**            media_issue = @i_view-media_issue AND
**            journal   = @i_view-journal.
**    IF sy-subrc IS INITIAL.
**      SORT i_contract_data BY contract
**                              item
**                              journal
**                              media_issue.
**    ENDIF.
**
**    SELECT * FROM zcds_claim_r115
**      INTO TABLE @i_claim_orders
**      FOR ALL ENTRIES IN @i_view
**      WHERE contract       = @i_view-contract AND
**            contract_item  = @i_view-item     AND
**            media_issue    = @i_view-media_issue.
**    IF sy-subrc IS INITIAL.
**      SORT i_claim_orders BY contract
**                             contract_item
**                             media_issue.
**    ENDIF.
**
**    SELECT * FROM zcds_clm_dup
**      INTO TABLE @i_dup_orders
**      FOR ALL ENTRIES IN @i_view
**      WHERE contract      = @i_view-contract AND
**            contract_item = @i_view-item     AND
**            media_issue   = @i_view-media_issue.
**    IF sy-subrc IS INITIAL.
**      SORT i_dup_orders BY contract
**                           contract_item
**                           media_issue.
**    ENDIF.
*
**    IF i_view IS NOT INITIAL.
**
**      LOOP AT i_view ASSIGNING <fs_view>.
**        IF <fs_view>-contract IS NOT INITIAL AND <fs_view>-item IS NOT INITIAL.
**          <fs_view>-value_per_issue = <fs_view>-net_value / <fs_view>-issue_count.
**
*** BOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
**          PERFORM f_build_final_output USING <fs_view>.         " Fill ALV output table
*** EOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
**
**        ENDIF.
**      ENDLOOP.
**
*** BOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
**      SORT i_view BY contract
**                     item
**                     journal
**                     media_issue.
*** EOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
**      DESCRIBE TABLE i_view LINES v_count.
**      SHIFT v_count LEFT DELETING LEADING '0'.
**      MESSAGE s001(zren) WITH v_count.
**    ELSE.
**      MESSAGE i000(zren) DISPLAY LIKE 'E'.
**      LEAVE LIST-PROCESSING.
**    ENDIF.
*
**  ELSE.
**    MESSAGE i000(zren) DISPLAY LIKE 'E'.
**    LEAVE LIST-PROCESSING.
**  ENDIF.
*
*    IF i_issue[] IS NOT INITIAL.
*      LOOP AT i_issue ASSIGNING <fs_issue>.
*        IF <fs_issue>-contract IS NOT INITIAL AND <fs_issue>-item IS NOT INITIAL.
**          <fs_view>-value_per_issue = <fs_view>-net_value / <fs_view>-issue_count.
*
*          PERFORM f_build_final_output USING <fs_issue>.         " Fill ALV output table
*
*        ENDIF.
*      ENDLOOP.
**    SORT i_issue BY contract
**                   item
**                   journal
**                   media_issue.
*      DESCRIBE TABLE i_alv_output LINES v_count.
*      SHIFT v_count LEFT DELETING LEADING '0'.
*      MESSAGE s001(zren) WITH v_count.
*    ENDIF.
*
*  ELSE. "IF cb_rar IS INITIAL.
* EOC ED2K925042 22-Nov-2021 TDIMANTHA
    SELECT  contract,
            item,
            media_issue,
            journal,
            contract_start_date,
            contract_end_date,
            acceptance_date,
            req_cancellation_date,
            item_category,
            cancel_reason,
            cancel_reason_desc,
            reason_for_cancel,
            cancelled_orders,
            overall_doc_status,
            overall_status_desc,
            credit_status,
            credit_status_desc,
            contract_qty,
            plant,
            mat_grp_5_code,
            mat_grp_5,
            mat_grp_3_code,
            mat_grp_3,
            net_value_item,
            currency,
            credit_block_flag,
            cancel_res_flag,
            reason_for_cancel_desc,
            cancelled_orders_desc,
            cancel_ord_flag
      FROM zcds_mip_005
      INTO TABLE @i_contract
      WHERE contract IN @s_sdoc
      AND   media_issue IN @s_issu
      AND   journal IN @s_prod
      AND   contract_start_date IN @s_csdt
      AND   contract_end_date IN @s_cedt
      AND   item_category IN @s_itcg
      AND   credit_block_flag EQ @c_excb
      AND   cancel_res_flag EQ @c_exro
      AND   cancel_ord_flag EQ @c_excc.

    IF i_contract[] IS NOT INITIAL.
      SORT i_contract.
      DELETE ADJACENT DUPLICATES FROM i_contract COMPARING ALL FIELDS.

      SELECT contract,
           item,
           media_issue,
           journal,
           rar_relevant,
           price_grp,
           price_grp_desc
      FROM zcds_mip_006
      INTO TABLE @i_issue
      FOR ALL ENTRIES IN @i_contract
      WHERE contract EQ @i_contract-contract
      AND   item EQ @i_contract-item
      AND   media_issue EQ @i_contract-media_issue
      AND   journal EQ @i_contract-journal.
      IF sy-subrc NE 0. "ED2K925042 06-Dec-2021 TDIMANTHA
        MESSAGE i000(zren) DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.

      SELECT contract,
              item,
              media_issue,
              journal,
              assignment,
              publication_date,
              actual_gi_date,
              profit_center,
              material_status,
              distr_chain_status,
              issue_number,
              vol_copy_no,
              year_number,
              publication_type,
              release_order_created,
              status,
              plan_status_desc,
              planned_ro_from,
              planned_ro_to,
              release_order,
              release_order_item,
              po_number,
              po_item,
              po_type,
              po_del_ind,
              po_info_rec,
              po_qty,
              delivery_number,
              delivery_item,
              purchase_requisition,
              purchase_requisition_item,
              mat_doc,
              mat_doc_item,
              mat_doc_type,
              mat_doc_year,
              mat_doc_date,
              billing_block,
              billing_block_desc,
              delivery_block,
              delivery_block_desc,
              sales_org,
              dist_channel,
              division,
              doc_type,
              sales_office,
              earned_amount,
              billed_amount,
              balance,
              document_currency,
              contract_reason,
              del_plant,
              bill_block_flag,
              del_block_flag,
              rel_ord_flag,
              unearned_flag,
              vendor,
              vendor_name,
              delivery_date,
              init_ship_date,
              dist_chain_status,
              mi_ic_group
        FROM zcds_mip_004
        INTO TABLE @i_podata
        FOR ALL ENTRIES IN @i_contract
        WHERE contract EQ @i_contract-contract
        AND   item EQ @i_contract-item
        AND   media_issue EQ @i_contract-media_issue
        AND   journal EQ @i_contract-journal
        AND   publication_date IN @s_pbdt
        AND   actual_gi_date IN @s_gddt
        AND   bill_block_flag EQ @c_exbb
        AND   del_block_flag EQ @c_exdb
        AND   rel_ord_flag EQ @c_irel
        AND   unearned_flag EQ @c_iamt
        AND   init_ship_date IN @s_indt
        AND   delivery_date IN @s_dldt
        AND   sales_org IN @s_sorg
        AND   dist_channel IN @s_dist
        AND   division IN @s_sdiv
        AND   sales_office IN @s_soff
        AND   assignment IN @s_assg
        AND   doc_type IN @s_dctp
        AND   release_order IN @s_rele.
        IF sy-subrc NE 0. "ED2K925042 06-Dec-2021 TDIMANTHA
          MESSAGE i000(zren) DISPLAY LIKE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.

      SELECT vbeln,
             posnr,
             issue_count,
             net_value,
             value_per_issue
        FROM zcds_mi_r115_2
        INTO TABLE @i_count
        FOR ALL ENTRIES IN @i_contract
        WHERE vbeln EQ @i_contract-contract
        AND   posnr EQ @i_contract-item.

      SELECT * FROM zcds_con_r115
        INTO TABLE @i_contract_data
        FOR ALL ENTRIES IN @i_contract
        WHERE contract = @i_contract-contract AND
              item     = @i_contract-item     AND
              media_issue = @i_contract-media_issue AND
              journal   = @i_contract-journal.
      IF sy-subrc IS INITIAL.
        SORT i_contract_data BY contract
                                item
                                journal
                                media_issue.
      ENDIF.
      IF rb11 IS NOT INITIAL. "When Release order details selected
        SELECT * FROM zcds_claim_r115
          INTO TABLE @i_claim_orders
          FOR ALL ENTRIES IN @i_contract
          WHERE contract       = @i_contract-contract AND
                contract_item  = @i_contract-item     AND
                media_issue    = @i_contract-media_issue.
        IF sy-subrc IS INITIAL.
          SORT i_claim_orders BY contract
                                 contract_item
                                 media_issue.
        ENDIF.

        SELECT * FROM zcds_clm_dup
          INTO TABLE @i_dup_orders
          FOR ALL ENTRIES IN @i_contract
          WHERE contract      = @i_contract-contract AND
                contract_item = @i_contract-item     AND
                media_issue   = @i_contract-media_issue.
        IF sy-subrc IS INITIAL.
          SORT i_dup_orders BY contract
                               contract_item
                               media_issue.
        ENDIF.
      ENDIF.
      SORT i_issue BY contract
                         item
                         journal
                         media_issue.
      SORT i_podata BY contract
                         item
                         journal
                         media_issue.
      SORT i_count BY    vbeln
                         posnr.
    ELSE. "IF i_issue[] INITIAL.
      MESSAGE i000(zren) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF. "IF i_issue[] IS NOT INITIAL.

    IF i_contract[] IS NOT INITIAL.
      LOOP AT i_contract ASSIGNING <fs_contract>.
        IF <fs_contract>-contract IS NOT INITIAL AND <fs_contract>-item IS NOT INITIAL.

          PERFORM f_build_final_output2 USING <fs_contract>.         " Fill ALV output table

        ENDIF.
      ENDLOOP.

      DESCRIBE TABLE i_alv_output LINES v_count.
      SHIFT v_count LEFT DELETING LEADING '0'.
      MESSAGE s001(zren) WITH v_count.
    ENDIF.

*  ENDIF. "IF cb_rar IS NOT INITIAL. "ED2K925042 22-Nov-2021 TDIMANTHA

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_build_fieldcatalog
*&---------------------------------------------------------------------*

FORM f_build_fieldcatalog .

  CLEAR:w_fieldcat,i_fieldcat[].

* BOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
  PERFORM f_build_fcatalog USING:
          'JOURNAL'                       'I_ALV_OUTPUT' text-f01 '' '18' '18',     "Media Product
          'MEDIA_ISSUE'                   'I_ALV_OUTPUT' text-f02 'X' '18' '18',    "Media Issue
          'CONTRACT'                      'I_ALV_OUTPUT' text-f19 'X' '10' '10',    "Contract Number
          'ITEM'                          'I_ALV_OUTPUT' text-f20 '' '6' '6',       "Contract Item
          'ASSIGNMENT'                    'I_ALV_OUTPUT' text-f74 '' '30' '30',     "Assignment
          'CONTRACT_CREATED'              'I_ALV_OUTPUT' text-f75 '' '' '',         "Contract creation date
          'REJECTION_USER'                'I_ALV_OUTPUT' text-f76 '' '12' '12',     "Contract rejection user
          'CONTRACT_SOLDTO'               'I_ALV_OUTPUT' text-f77 '' '' '',         "Contract sold to
          'CONTRACT_SOLDTO_NAME'          'I_ALV_OUTPUT' text-f78 '' '' '',         "Contract sold to name
          'CONTRACT_SHIPTO'               'I_ALV_OUTPUT' text-f79 '' '' '',         "Contrct ship to
          'CONTRACT_SHIPTO_NAME'          'I_ALV_OUTPUT' text-f80 '' '' '',         "contract ship to name
          'CONTRACT_SHIPTO_CTRY'          'I_ALV_OUTPUT' text-f81 '' '' '',         "Contract ship to country
          'ITEM_CATEGORY'                 'I_ALV_OUTPUT' text-f29 '' '4' '4',       "Item Category
          'DOC_TYPE'                      'I_ALV_OUTPUT' text-f21 '' '4' '4',       "Doc Type
          'CONTRACT_REASON'               'I_ALV_OUTPUT' text-f22 '' '100' '100',   "Contract Reason
          'CONTRACT_START_DATE'           'I_ALV_OUTPUT' text-f23 '' '' '',         "Contract Start Date
          'CONTRACT_END_DATE'             'I_ALV_OUTPUT' text-f24 '' '' '',         "Contract End Date
          'CONTRACT_QTY'                  'I_ALV_OUTPUT' text-f25 '' '' '',         "Contract Qty
          'PLANT'                         'I_ALV_OUTPUT' text-f26 '' '4' '4',       "Contract Plant
          'MAT_GRP_5'                     'I_ALV_OUTPUT' text-f27 '' '100' '100',   "Material Grp 5
          'MAT_GRP_3'                     'I_ALV_OUTPUT' text-f28 '' '100' '100',   "Material Grp 3
          'NET_VALUE_ITEM'                'I_ALV_OUTPUT' text-f30 '' '' '',         "Net Value (Item)
          'CURRENCY'                      'I_ALV_OUTPUT' text-f31 '' '5' '5',       "Currency
          'BILLING_BLOCK_DESC'            'I_ALV_OUTPUT' text-f32 '' '50' '50',     "Billing Block
          'DELIVERY_BLOCK_DESC'           'I_ALV_OUTPUT' text-f33 '' '50' '50',     "Delivery Block
          'OVERALL_STATUS_DESC'           'I_ALV_OUTPUT' text-f34 '' '50' '50',     "Overall Contract Status
          'CREDIT_STATUS_DESC'            'I_ALV_OUTPUT' text-f35 '' '50' '50',     "Credit Status
          'CANCEL_REASON_DESC'            'I_ALV_OUTPUT' text-f36 '' '100' '100',   "Rejection Reason
          'CANCELLED_ORDERS_DESC'         'I_ALV_OUTPUT' text-f37 '' '100' '100',   "Contract Cancellation
          'REASON_FOR_CANCEL_DESC'        'I_ALV_OUTPUT' text-f38 '' '100' '100',   "Cancellation Reason
          'ACCEPTANCE_DATE'               'I_ALV_OUTPUT' text-f39 '' '' '',         "Acceptance Date
          'REQ_CANCELLATION_DATE'         'I_ALV_OUTPUT' text-f40 '' '' '',         "Requested Cancellation Date
          'PRICE_GRP_DESC'                'I_ALV_OUTPUT' text-f41 '' '50' '50',     "Price Group
          'DELIVERY_NUMBER'               'I_ALV_OUTPUT' text-f42 '' '10' '10',     "Delivery Number
          'DELIVERY_ITEM'                 'I_ALV_OUTPUT' text-f43 '' '6' '6',       "Delivery Item
          'MAT_DOC'                       'I_ALV_OUTPUT' text-f44 '' '10' '10',     "Material Doc
          'MAT_DOC_ITEM'                  'I_ALV_OUTPUT' text-f45 '' '6' '6',       "Material Doc Item
          'MAT_DOC_TYPE'                  'I_ALV_OUTPUT' text-f46 '' '3' '3',       "Material Doc Type
          'MAT_DOC_YEAR'                  'I_ALV_OUTPUT' text-f47 '' '4' '4',       "Material Doc Year
          'MAT_DOC_DATE'                  'I_ALV_OUTPUT' text-f48 '' '' '',         "Material Doc Posting Date
          'PO_NUMBER'                     'I_ALV_OUTPUT' text-f49 '' '10' '10',     "Purchase Orer
          'PO_ITEM'                       'I_ALV_OUTPUT' text-f50 '' '6' '6' ,      "PO Item
          'PO_TYPE'                       'I_ALV_OUTPUT' text-f51 '' '4' '4',       "PO Type
          'PO_DEL_IND'                    'I_ALV_OUTPUT' text-f52 '' '1' '1',       "PO Deletion Indicator
          'PO_INFO_REC'                   'I_ALV_OUTPUT' text-f53 '' '10' '10',     "Purchasing Info Record
          'PO_QTY'                        'I_ALV_OUTPUT' text-f54 '' '' '',         "PO Qty
          'VALUE_PER_ISSUE'               'I_ALV_OUTPUT' text-f55 '' '' '',         "Single Issue Value
          'EARNED_AMOUNT'                 'I_ALV_OUTPUT' text-f56 '' '' '',         "Earned Amount
          'BALANCE'                       'I_ALV_OUTPUT' text-f58 '' '' '',         "Balance Amount
          'DOCUMENT_CURRENCY'             'I_ALV_OUTPUT' text-f59 '' '5' '5',       "Document Currency
          'RELEASE_ORDER_CREATED'         'I_ALV_OUTPUT' text-f60 '' '1' '1',       "Release Order Created
          'RELEASE_ORDER'                 'I_ALV_OUTPUT' text-f61 'X' '10' '10',     "Release Order
          'RELEASE_ORDER_ITEM'            'I_ALV_OUTPUT' text-f62 '' '6' '6',       "Release order item
          'PURCHASE_REQUISITION'          'I_ALV_OUTPUT' text-f63 '' '10' '10',     "Purchase Requisition
          'PURCHASE_REQUISITION_ITEM'     'I_ALV_OUTPUT' text-f64 '' '6' '6',       "PR Item
          'VENDOR'                        'I_ALV_OUTPUT' text-f70 '' '250' '250',   "Vendor
          'VENDOR_NAME'                   'I_ALV_OUTPUT' text-f71 '' '35' '35',     "Vendor Name
          'RELEVANT_RAR'                  'I_ALV_OUTPUT' text-f65 '' '10' '10',     "Relevant for RAR
          'SALES_ORG'                     'I_ALV_OUTPUT' text-f66 '' '4' '4',       "Sales Org
          'DIST_CHANNEL'                  'I_ALV_OUTPUT' text-f67 '' '2' '2',       "Dist. Channel
          'DIVISION'                      'I_ALV_OUTPUT' text-f68 '' '2' '2',       "Division
          'SALES_OFFICE'                  'I_ALV_OUTPUT' text-f69 '' '4' '4',       "Sales Office
          'CLAIMS_ORDER'                  'I_ALV_OUTPUT' text-f82 'X' '10' '10',    "Claim Order Number
          'CLAIMS_ITEM'                   'I_ALV_OUTPUT' text-f83 '' '6' '6',       "Claim Order
          'DUPLICATE_COUNT'               'I_ALV_OUTPUT' text-f84 'X' '' '',         "Duplicate Order count
          'INVOICE_NUMBER'                'I_ALV_OUTPUT' text-f85 '' '' ''          "Invoice Number
.

* EOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCATALOG
*&---------------------------------------------------------------------*
*  --> fp_field        Field Name
*  --> fp_tab           Table Name
*  --> fp_text          Selection Text
*----------------------------------------------------------------------*
FORM f_build_fcatalog USING fp_field TYPE any
                            fp_tab   TYPE any
                            fp_text  TYPE any
                            fp_hotspot TYPE any
                            fp_ddout TYPE any
                            fp_outlen TYPE any.
*                            fp_do_sum TYPE any
*                            fp_cfieldname TYPE any.
*    w_fieldcat-do_sum         = 'X'.
*    w_fieldcat-cfieldname     = 'CURRENCY'..

  w_fieldcat-fieldname      = fp_field.
  w_fieldcat-tabname        = fp_tab.
  w_fieldcat-seltext_l      = fp_text.
  w_fieldcat-lowercase      = abap_true.
  w_fieldcat-hotspot        = fp_hotspot.
  w_fieldcat-ddic_outputlen = fp_ddout.
  w_fieldcat-outputlen      = fp_outlen.

  APPEND w_fieldcat TO i_fieldcat.
  CLEAR w_fieldcat.

ENDFORM.                    " f_build_fieldcatalog
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  f_build_layout
*&---------------------------------------------------------------------*
FORM f_build_layout .
  w_layout-colwidth_optimize = 'X'.
  w_layout-zebra             = 'X'.

ENDFORM.                    " f_build_layout
*&---------------------------------------------------------------------*
*&      Form  f_list_display
*&---------------------------------------------------------------------*
FORM f_list_display .
  DATA:
  v_program TYPE sy-repid.
  v_program = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = v_program
      is_layout                = w_layout
      i_callback_user_command  = 'F_HANDLE_USER_COMMAND' "To handle user command
      i_callback_pf_status_set = 'F_SET_PF_STATUS'
      it_fieldcat              = i_fieldcat
      i_save                   = 'A'
* BOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *
      is_variant               = st_variant
* EOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *
    TABLES
* BOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *
      t_outtab                 = i_alv_output
* EOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE text-e01 TYPE 'E'. "E01 - 'Program Error'
      WHEN 2.
        MESSAGE text-e02 TYPE 'E'. "E02 - 'Others'
    ENDCASE.
  ENDIF.

ENDFORM.                    " f_list_display

**&---------------------------------------------------------------------*
**&      Form  f_handle_user_command
**&---------------------------------------------------------------------*
FORM f_handle_user_command USING r_ucomm     LIKE sy-ucomm
                                 rs_selfield TYPE slis_selfield.

  CASE r_ucomm.
    WHEN '&IC1'.
      CASE rs_selfield-fieldname.
        WHEN 'CONTRACT'.
*  Parameter ID 'AGN' refers to Quotation Number

          SET PARAMETER ID 'AGN' FIELD rs_selfield-value. "v_vbeln.
          CALL TRANSACTION 'VA23' AND SKIP FIRST SCREEN.

*        WHEN 'BILLING_DOC_NUMBER'.
**  Parameter ID 'VF' refers to Quotation Number
*          SET PARAMETER ID 'VF' FIELD rs_selfield-value. "v_vbeln.
*          CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
* BOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
        WHEN c_release_order.     " Release order'.
          READ TABLE i_alv_output INTO DATA(lst_alv_row_ro) INDEX rs_selfield-tabindex.
          IF sy-subrc = 0.
            PERFORM f_populate_ro_data USING lst_alv_row_ro.
          ENDIF.
        WHEN c_media_issue.       " Media Issue
          READ TABLE i_alv_output INTO DATA(lst_alv_row_mdata) INDEX rs_selfield-tabindex.
          IF sy-subrc = 0.
            PERFORM f_populate_mdata USING lst_alv_row_mdata.
          ENDIF.
        WHEN c_claims_order.      " Claim Orders
          READ TABLE i_alv_output INTO DATA(lst_alv_row_claim) INDEX rs_selfield-tabindex.
          IF sy-subrc = 0.
            PERFORM f_populate_claim USING lst_alv_row_claim.
          ENDIF.
        WHEN c_duplicate_count.   " Duplicate count.
          READ TABLE i_alv_output INTO DATA(lst_alv_row_dup) INDEX rs_selfield-tabindex.
          IF sy-subrc = 0.
            PERFORM f_populate_dup_orders USING lst_alv_row_dup.
          ENDIF.
* EOC by Lahiru on 02/22/2021 for OTCM-29592 with ED2K921929  *
      ENDCASE.
    WHEN c_download.              " Download data to excel '&DOWNLOAD'.
      PERFORM f_prepare_excel_headers.
      PERFORM f_prepare_excel_data.
      PERFORM f_download_excel.
  ENDCASE.

ENDFORM.                    " f_handle_user_command

***&---------------------------------------------------------------------*
***&      Form  f_handle_user_command
***&---------------------------------------------------------------------*
FORM f_set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZPF_STATUS_R115'.
ENDFORM. "Set_pf_status

FORM f_alv_variant_value_request CHANGING fp_p_alv_vr.

  DATA: lst_variant TYPE disvariant,
        lv_exit     TYPE char1.

  CLEAR : lst_variant , lv_exit.

* Display all existing ALV variants
  lst_variant-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = lst_variant
      i_save     = abap_true
    IMPORTING
      e_exit     = lv_exit
      es_variant = st_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE 'S'
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ELSE.
    IF lv_exit = space.
      fp_p_alv_vr = st_variant-variant.
    ENDIF.
  ENDIF.

ENDFORM.

FORM f_validate_alv_variant USING fp_p_alv_vr.

  DATA: lst_variant TYPE disvariant.

  CLEAR lst_variant.
  lst_variant-variant = fp_p_alv_vr.
  lst_variant-report  = sy-repid.

  " checking whether selected vriant is avaible or not
  CALL FUNCTION 'LVC_VARIANT_EXISTENCE_CHECK'
    EXPORTING
      i_save        = space                   " Variants Can be Saved
    CHANGING
      cs_variant    = lst_variant             " Variant information
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3.
  IF sy-subrc EQ 0.
    st_variant = lst_variant.
  ELSE.
    MESSAGE s586(zqtc_r2) WITH fp_p_alv_vr DISPLAY LIKE c_errtype.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

FORM f_build_final_output  USING fp_view TYPE t_issue.
  DATA: ls_alv_output TYPE zstqtc_alvoutput_r115.
  CLEAR ls_alv_output.

*  APPEND INITIAL LINE TO i_alv_output ASSIGNING FIELD-SYMBOL(<lfs_alv_output>).
  ls_alv_output-journal                = fp_view-journal.
  ls_alv_output-media_issue            = fp_view-media_issue.
  ls_alv_output-contract               = fp_view-contract.
  ls_alv_output-item                   = fp_view-item.
  ls_alv_output-price_grp_desc         = fp_view-price_grp_desc.
  ls_alv_output-relevant_rar           = fp_view-rar_relevant.
  ls_alv_output-price_grp_desc         = fp_view-price_grp_desc.

  IF i_contract IS NOT INITIAL.
    READ TABLE i_contract ASSIGNING FIELD-SYMBOL(<lfs_contract>) WITH KEY contract = fp_view-contract
                                                                          item     = fp_view-item
                                                                          journal  = fp_view-journal
                                                                          media_issue = fp_view-media_issue BINARY SEARCH.
    IF <lfs_contract> IS ASSIGNED.
      ls_alv_output-item_category          = <lfs_contract>-item_category.
      ls_alv_output-contract_start_date    = <lfs_contract>-contract_start_date.
      ls_alv_output-contract_end_date      = <lfs_contract>-contract_end_date.
      ls_alv_output-contract_qty           = <lfs_contract>-contract_qty.
      ls_alv_output-plant                  = <lfs_contract>-plant.
      ls_alv_output-mat_grp_5              = <lfs_contract>-mat_grp_5.
      ls_alv_output-mat_grp_3              = <lfs_contract>-mat_grp_3.
      ls_alv_output-net_value_item         = <lfs_contract>-net_value_item.
      ls_alv_output-currency               = <lfs_contract>-currency.
      ls_alv_output-overall_status_desc    = <lfs_contract>-overall_status_desc.
      ls_alv_output-credit_status_desc     = <lfs_contract>-credit_status_desc.
      ls_alv_output-cancel_reason_desc     = <lfs_contract>-cancel_reason_desc.
      ls_alv_output-cancelled_orders_desc  = <lfs_contract>-cancelled_orders_desc.
      ls_alv_output-reason_for_cancel_desc = <lfs_contract>-reason_for_cancel_desc.
      ls_alv_output-acceptance_date        = <lfs_contract>-acceptance_date.
      ls_alv_output-req_cancellation_date  = <lfs_contract>-req_cancellation_date.
    ELSE.
      EXIT.
    ENDIF.
  ENDIF.

  IF i_podata IS NOT INITIAL.
    READ TABLE i_podata ASSIGNING FIELD-SYMBOL(<lfs_podata>) WITH KEY contract = fp_view-contract
                                                                      item     = fp_view-item
                                                                      journal  = fp_view-journal
                                                                      media_issue = fp_view-media_issue BINARY SEARCH.
    IF <lfs_podata> IS ASSIGNED.
      ls_alv_output-assignment             = <lfs_podata>-assignment.
      ls_alv_output-contract_reason        = <lfs_podata>-contract_reason.
      ls_alv_output-billing_block_desc     = <lfs_podata>-billing_block_desc.
      ls_alv_output-delivery_block_desc    = <lfs_podata>-delivery_block_desc.
      ls_alv_output-delivery_number        = <lfs_podata>-delivery_number.
      ls_alv_output-delivery_item          = <lfs_podata>-delivery_item.
      ls_alv_output-mat_doc                = <lfs_podata>-mat_doc.
      ls_alv_output-mat_doc_item           = <lfs_podata>-mat_doc_item.
      ls_alv_output-mat_doc_type           = <lfs_podata>-mat_doc_type.
      ls_alv_output-mat_doc_year           = <lfs_podata>-mat_doc_year.
      ls_alv_output-mat_doc_date           = <lfs_podata>-mat_doc_date.
      ls_alv_output-po_number              = <lfs_podata>-po_number.
      ls_alv_output-po_item                = <lfs_podata>-po_item.
      ls_alv_output-po_type                = <lfs_podata>-po_type.
      ls_alv_output-po_del_ind             = <lfs_podata>-po_del_ind.
      ls_alv_output-po_info_rec            = <lfs_podata>-po_info_rec.
      ls_alv_output-po_qty                 = <lfs_podata>-po_qty.
      ls_alv_output-vendor                 = <lfs_podata>-vendor.
      ls_alv_output-vendor_name            = <lfs_podata>-vendor_name.
      ls_alv_output-earned_amount          = <lfs_podata>-earned_amount.
      ls_alv_output-balance                = <lfs_podata>-balance.
      ls_alv_output-release_order_created  = <lfs_podata>-release_order_created.
      ls_alv_output-release_order          = <lfs_podata>-release_order.
      ls_alv_output-release_order_item     = <lfs_podata>-release_order_item.
      ls_alv_output-doc_type               = <lfs_podata>-doc_type.
      ls_alv_output-document_currency      = <lfs_podata>-document_currency.
      ls_alv_output-purchase_requisition   = <lfs_podata>-purchase_requisition.
      ls_alv_output-purchase_requisition_item = <lfs_podata>-purchase_requisition_item.
      ls_alv_output-sales_org              = <lfs_podata>-sales_org.
      ls_alv_output-dist_channel           = <lfs_podata>-dist_channel.
      ls_alv_output-division               = <lfs_podata>-division.
      ls_alv_output-sales_office           = <lfs_podata>-sales_office.
    ELSE.
      EXIT.
    ENDIF.
  ENDIF.

  IF i_count IS NOT INITIAL.
    READ TABLE i_count ASSIGNING FIELD-SYMBOL(<lfs_count>) WITH KEY vbeln = fp_view-contract
                                                                    posnr = fp_view-item BINARY SEARCH.
    IF <lfs_count> IS ASSIGNED.
      ls_alv_output-value_per_issue     = <lfs_count>-value_per_issue.
    ENDIF.
  ENDIF.

  " Read contract document related data
  IF i_contract_data IS NOT INITIAL.
    READ TABLE i_contract_data ASSIGNING FIELD-SYMBOL(<lfs_contract_data>) WITH KEY contract = fp_view-contract
                                                                                    item     = fp_view-item
                                                                                    journal  = fp_view-journal
                                                                                    media_issue = fp_view-media_issue BINARY SEARCH.
    IF sy-subrc = 0.
      ls_alv_output-contract_created     = <lfs_contract_data>-contract_created.
      ls_alv_output-rejection_user       = <lfs_contract_data>-rejection_user.
      ls_alv_output-contract_soldto      = <lfs_contract_data>-contract_soldto.
      ls_alv_output-contract_soldto_name = <lfs_contract_data>-contract_soldto_name.
      ls_alv_output-contract_shipto      = <lfs_contract_data>-contract_shipto.
      ls_alv_output-contract_shipto_name = <lfs_contract_data>-contract_shipto_name.
      ls_alv_output-contract_shipto_ctry = <lfs_contract_data>-contract_shipto_ctry.
      ls_alv_output-invoice_number       = <lfs_contract_data>-invoice_number.
    ENDIF.
  ENDIF.

  " Read claim order data.
  IF i_claim_orders IS NOT INITIAL.
    READ TABLE i_claim_orders ASSIGNING <gfs_claim_orders> WITH KEY contract      = fp_view-contract
                                                                    contract_item = fp_view-item
                                                                    media_issue   = fp_view-media_issue BINARY SEARCH.
    IF sy-subrc = 0.
      ls_alv_output-claims_order = <gfs_claim_orders>-claims_order.
      ls_alv_output-claims_item  = <gfs_claim_orders>-claims_item.
    ENDIF.
  ENDIF.

  " Read Duplicate order count
  IF i_dup_orders IS NOT INITIAL.
    READ TABLE i_dup_orders  ASSIGNING FIELD-SYMBOL(<lfs_dup_orders>) WITH KEY contract      = fp_view-contract
                                                                               contract_item = fp_view-item
                                                                               media_issue   = fp_view-media_issue BINARY SEARCH.
    IF sy-subrc = 0.
      ls_alv_output-duplicate_count = <lfs_dup_orders>-row_count.
    ENDIF.
  ENDIF.
  APPEND ls_alv_output TO i_alv_output.
ENDFORM.

FORM f_populate_ro_data  USING fp_lst_alv_row_ro TYPE zstqtc_alvoutput_r115.

  " Fetch release order data based on selected release order and l/item
  SELECT release_order,
         release_order_item,
         release_order_type,
         release_order_date,
         release_order_item_categ,
         ro_sch_line_category,
         rel_ord_rejection_date,
         rel_ord_rejection_user,
         ro_del_block,
         rel_ord_delblk_date,
         rel_ord_delblk_user,
         confirmation_status,
         pr_deletion,
         rel_ord_qty,
         rel_ord_del_date
    FROM zcds_relord_r115
    INTO TABLE @DATA(li_ro_data)
    WHERE release_order = @fp_lst_alv_row_ro-release_order     AND
          release_order_item = @fp_lst_alv_row_ro-release_order_item.
  IF sy-subrc IS INITIAL.
    SORT li_ro_data BY release_order release_order_item.
    PERFORM f_build_ro_output TABLES li_ro_data.      " build release order data Popup grid
  ELSE.
    MESSAGE text-m01 TYPE c_infotype.     " No data for the current selection
  ENDIF.

ENDFORM.

FORM f_build_ro_output TABLES fp_li_ro_data .

  DATA: li_fieldcat_ro  TYPE slis_t_fieldcat_alv,
        lst_fieldcat_ro LIKE LINE OF li_fieldcat_ro.

  REFRESH : li_fieldcat_ro.

  " Build Popup list field catalog
  lst_fieldcat_ro-col_pos = 1.
  lst_fieldcat_ro-fieldname = 'RELEASE_ORDER_ITEM'.
  lst_fieldcat_ro-seltext_l =  text-f62.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 2.
  lst_fieldcat_ro-fieldname = 'RELEASE_ORDER_TYPE'.
  lst_fieldcat_ro-seltext_l =  text-r01.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 3.
  lst_fieldcat_ro-fieldname = 'RELEASE_ORDER_DATE'.
  lst_fieldcat_ro-seltext_l = text-r02.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 4.
  lst_fieldcat_ro-fieldname = 'RELEASE_ORDER_ITEM_CATEG'.
  lst_fieldcat_ro-seltext_l = text-r03.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 5.
  lst_fieldcat_ro-fieldname = 'RO_SCH_LINE_CATEGORY'.
  lst_fieldcat_ro-seltext_l = text-r04.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 6.
  lst_fieldcat_ro-fieldname = 'REL_ORD_REJECTION_DATE'.
  lst_fieldcat_ro-seltext_l = text-r05.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 7.
  lst_fieldcat_ro-fieldname = 'REL_ORD_REJECTION_USER'.
  lst_fieldcat_ro-seltext_l = text-r06.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 8.
  lst_fieldcat_ro-fieldname = 'RO_DEL_BLOCK'.
  lst_fieldcat_ro-seltext_l = text-r07.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 9.
  lst_fieldcat_ro-fieldname = 'REL_ORD_DELBLK_DATE'.
  lst_fieldcat_ro-seltext_l = text-r08.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 10.
  lst_fieldcat_ro-fieldname = 'REL_ORD_DELBLK_USER'.
  lst_fieldcat_ro-seltext_l = text-r09.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 11.
  lst_fieldcat_ro-fieldname = 'CONFIRMATION_STATUS'.
  lst_fieldcat_ro-seltext_l = text-r10.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 12.
  lst_fieldcat_ro-fieldname = 'PR_DELETION'.
  lst_fieldcat_ro-seltext_l = text-r11.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 13.
  lst_fieldcat_ro-fieldname = 'REL_ORD_QTY'.
  lst_fieldcat_ro-seltext_l = text-r12.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.

  lst_fieldcat_ro-col_pos = 14.
  lst_fieldcat_ro-fieldname = 'REL_ORD_DEL_DATE'.
  lst_fieldcat_ro-seltext_l = text-r13.
  lst_fieldcat_ro-tabname = 'FP_LI_RO_DATA'.
  APPEND lst_fieldcat_ro TO li_fieldcat_ro.
  CLEAR lst_fieldcat_ro.


  " Popup the list with filed names
  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = text-007 "'Release Order Details'
      i_zebra               = abap_true
      i_screen_start_column = 20
      i_screen_start_line   = 3
      i_screen_end_column   = 130
      i_screen_end_line     = 20
      i_tabname             = 'FP_LI_RO_DATA'
      it_fieldcat           = li_fieldcat_ro
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = fp_li_ro_data
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM f_populate_mdata USING fp_lst_alv_row_mdata TYPE zstqtc_alvoutput_r115.

  TYPES  : BEGIN OF lty_mdata,
             publication_date   TYPE ismpubldate,
             actual_gi_date     TYPE erdat,
             material_status    TYPE char50,
             distr_chain_status TYPE char50,
             mi_ic_group        TYPE char50,
             dist_chain_status  TYPE char50,
             issue_number       TYPE ismnrimjahr,
             vol_copy_no        TYPE ismheftnummer,
             year_number        TYPE ismjahrgang,
             publication_type   TYPE ismausgvartyppl,
             del_plant          TYPE dwerk_ext,
             profit_center      TYPE char10,
             init_ship_date     TYPE ismerstverdat,
             delivery_date      TYPE jshipping_date,
             plan_status_desc   TYPE char30,
             planned_ro_from    TYPE jgen_start_date,
             planned_ro_to      TYPE jgen_end_date,
           END OF lty_mdata.

  DATA : li_mdata TYPE STANDARD TABLE OF lty_mdata INITIAL SIZE 0.

  " Read Master data fro the main data source
*  READ TABLE i_view ASSIGNING <fs_view> WITH KEY contract = fp_lst_alv_row_mdata-contract
*                                                 item     = fp_lst_alv_row_mdata-item
*                                                 journal  = fp_lst_alv_row_mdata-journal
*                                                 media_issue = fp_lst_alv_row_mdata-media_issue BINARY SEARCH.
  READ TABLE i_podata ASSIGNING <fs_podata> WITH KEY contract = fp_lst_alv_row_mdata-contract
                                                 item     = fp_lst_alv_row_mdata-item
                                                 journal  = fp_lst_alv_row_mdata-journal
                                                 media_issue = fp_lst_alv_row_mdata-media_issue BINARY SEARCH.
  IF sy-subrc = 0.
    REFRESH li_mdata.
    APPEND INITIAL LINE TO li_mdata ASSIGNING FIELD-SYMBOL(<lfs_mdata>).
    <lfs_mdata>-publication_date   = <fs_podata>-publication_date.
    <lfs_mdata>-actual_gi_date     = <fs_podata>-actual_gi_date.
    <lfs_mdata>-material_status    = <fs_podata>-material_status.
    <lfs_mdata>-distr_chain_status = <fs_podata>-distr_chain_status.
    <lfs_mdata>-mi_ic_group        = <fs_podata>-mi_ic_group.
    <lfs_mdata>-dist_chain_status  = <fs_podata>-dist_chain_status.
    <lfs_mdata>-issue_number       = <fs_podata>-issue_number.
    <lfs_mdata>-vol_copy_no        = <fs_podata>-vol_copy_no.
    <lfs_mdata>-year_number        = <fs_podata>-year_number.
    <lfs_mdata>-publication_type   = <fs_podata>-publication_type.
    <lfs_mdata>-del_plant          = <fs_podata>-del_plant.
    <lfs_mdata>-profit_center      = <fs_podata>-profit_center.
    <lfs_mdata>-init_ship_date     = <fs_podata>-init_ship_date.
    <lfs_mdata>-delivery_date      = <fs_podata>-delivery_date.
    <lfs_mdata>-plan_status_desc   = <fs_podata>-plan_status_desc.
    <lfs_mdata>-planned_ro_from    = <fs_podata>-planned_ro_from.
    <lfs_mdata>-planned_ro_to      = <fs_podata>-planned_ro_to.

    PERFORM f_build_mdata_output TABLES li_mdata.      " build Master data Popup grid
  ELSE.
    MESSAGE text-m01 TYPE c_infotype.     " No data for the current selection
  ENDIF.

ENDFORM.

FORM f_build_mdata_output TABLES fp_li_mdata.

  DATA: li_fieldcat_mdata  TYPE slis_t_fieldcat_alv,
        lst_fieldcat_mdata LIKE LINE OF li_fieldcat_mdata.

  REFRESH : li_fieldcat_mdata.

  " Build Popup list field catalog
  lst_fieldcat_mdata-col_pos = 1.
  lst_fieldcat_mdata-fieldname = 'PUBLICATION_DATE'.
  lst_fieldcat_mdata-seltext_l =  text-f03.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 2.
  lst_fieldcat_mdata-fieldname = 'ACTUAL_GI_DATE'.
  lst_fieldcat_mdata-seltext_l = text-f04.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 3.
  lst_fieldcat_mdata-fieldname = 'MATERIAL_STATUS'.
  lst_fieldcat_mdata-seltext_l = text-f05.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 4.
  lst_fieldcat_mdata-fieldname = 'DISTR_CHAIN_STATUS'.
  lst_fieldcat_mdata-seltext_l = text-f06.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 5.
  lst_fieldcat_mdata-fieldname = 'MI_IC_GROUP'.
  lst_fieldcat_mdata-seltext_l = text-f07.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 6.
  lst_fieldcat_mdata-fieldname = 'DIST_CHAIN_STATUS'.
  lst_fieldcat_mdata-seltext_l = text-f08.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 7.
  lst_fieldcat_mdata-fieldname = 'ISSUE_NUMBER'.
  lst_fieldcat_mdata-seltext_l = text-f09.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 8.
  lst_fieldcat_mdata-fieldname = 'VOL_COPY_NO'.
  lst_fieldcat_mdata-seltext_l = text-f10.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 9.
  lst_fieldcat_mdata-fieldname = 'YEAR_NUMBER'.
  lst_fieldcat_mdata-seltext_l = text-f11.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 10.
  lst_fieldcat_mdata-fieldname = 'PUBLICATION_TYPE'.
  lst_fieldcat_mdata-seltext_l = text-f12.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 11.
  lst_fieldcat_mdata-fieldname = 'DEL_PLANT'.
  lst_fieldcat_mdata-seltext_l = text-f13.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 12.
  lst_fieldcat_mdata-fieldname = 'PROFIT_CENTER'.
  lst_fieldcat_mdata-seltext_l = text-f14.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 13.
  lst_fieldcat_mdata-fieldname = 'INIT_SHIP_DATE'.
  lst_fieldcat_mdata-seltext_l = text-f72.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 14.
  lst_fieldcat_mdata-fieldname = 'DELIVERY_DATE'.
  lst_fieldcat_mdata-seltext_l = text-f73.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 15.
  lst_fieldcat_mdata-fieldname = 'PLAN_STATUS_DESC'.
  lst_fieldcat_mdata-seltext_l = text-f15.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 16.
  lst_fieldcat_mdata-fieldname = 'PLANNED_RO_FROM'.
  lst_fieldcat_mdata-seltext_l = text-f17.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.

  lst_fieldcat_mdata-col_pos = 17.
  lst_fieldcat_mdata-fieldname = 'PLANNED_RO_TO'.
  lst_fieldcat_mdata-seltext_l = text-f18.
  lst_fieldcat_mdata-tabname = 'FP_LI_MDATA'.
  APPEND lst_fieldcat_mdata TO li_fieldcat_mdata.
  CLEAR lst_fieldcat_mdata.


  " Popup the list with filed names
  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = text-008      "Master data Details
      i_zebra               = abap_true
      i_screen_start_column = 20
      i_screen_start_line   = 3
      i_screen_end_column   = 130
      i_screen_end_line     = 20
      i_tabname             = 'FP_LI_MDATA'
      it_fieldcat           = li_fieldcat_mdata
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = fp_li_mdata
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM f_populate_claim  USING fp_lst_alv_row_claim TYPE zstqtc_alvoutput_r115.

  DATA(li_claims_tmp) = i_claim_orders[].
  SORT li_claims_tmp BY contract
                        contract_item
                        media_issue.
  DELETE ADJACENT DUPLICATES FROM li_claims_tmp COMPARING contract
                                                          contract_item
                                                          media_issue.

  DELETE li_claims_tmp WHERE contract NE fp_lst_alv_row_claim-contract AND
                             contract_item NE fp_lst_alv_row_claim-item AND
                             media_issue  NE fp_lst_alv_row_claim-media_issue.

  IF li_claims_tmp IS NOT INITIAL.
    PERFORM f_build_claims_output TABLES li_claims_tmp.
  ELSE.
    MESSAGE text-m01 TYPE c_infotype.     " No data for the current selection
  ENDIF.


ENDFORM.

FORM f_build_claims_output TABLES fp_li_claims_tmp.

  DATA: li_fieldcat_claims  TYPE slis_t_fieldcat_alv,
        lst_fieldcat_claims LIKE LINE OF li_fieldcat_claims.

  REFRESH : li_fieldcat_claims.

  " Build Popup list field catalog
  lst_fieldcat_claims-col_pos = 1.
  lst_fieldcat_claims-fieldname = 'CLAIMS_ITEM'.
  lst_fieldcat_claims-seltext_l =  text-c01.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 2.
  lst_fieldcat_claims-fieldname = 'CONFIRMATION_STATUS'.
  lst_fieldcat_claims-seltext_l = text-c02.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 3.
  lst_fieldcat_claims-fieldname = 'QUANTITY'.
  lst_fieldcat_claims-seltext_l = text-c03.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 4.
  lst_fieldcat_claims-fieldname = 'CREATED_DATE'.
  lst_fieldcat_claims-seltext_l = text-c04.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 5.
  lst_fieldcat_claims-fieldname = 'ITEM_CATEG'.
  lst_fieldcat_claims-seltext_l = text-c05.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 6.
  lst_fieldcat_claims-fieldname = 'SCH_LINE_CATEG'.
  lst_fieldcat_claims-seltext_l = text-c06.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 7.
  lst_fieldcat_claims-fieldname = 'CANCEL_REASON_DESC'.
  lst_fieldcat_claims-seltext_l = text-c07.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 8.
  lst_fieldcat_claims-fieldname = 'REJECTION_DATE'.
  lst_fieldcat_claims-seltext_l = text-c08.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 9.
  lst_fieldcat_claims-fieldname = 'REJECTION_USER'.
  lst_fieldcat_claims-seltext_l = text-c09.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 10.
  lst_fieldcat_claims-fieldname = 'DELIV_BLOCK'.
  lst_fieldcat_claims-seltext_l = text-c10.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 11.
  lst_fieldcat_claims-fieldname = 'DELIV_NUM'.
  lst_fieldcat_claims-seltext_l = text-c11.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 12.
  lst_fieldcat_claims-fieldname = 'DELIV_ITEM'.
  lst_fieldcat_claims-seltext_l = text-c12.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.

  lst_fieldcat_claims-col_pos = 13.
  lst_fieldcat_claims-fieldname = 'PGI_DOC'.
  lst_fieldcat_claims-seltext_l = text-c13.
  lst_fieldcat_claims-tabname = 'FP_LI_CLAIMS_TMP'.
  APPEND lst_fieldcat_claims TO li_fieldcat_claims.
  CLEAR lst_fieldcat_claims.


  " Popup the list with filed names
  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = text-009      "Claim order details
      i_zebra               = abap_true
      i_screen_start_column = 20
      i_screen_start_line   = 3
      i_screen_end_column   = 130
      i_screen_end_line     = 20
      i_tabname             = 'FP_LI_CLAIMS_TMP'
      it_fieldcat           = li_fieldcat_claims
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = fp_li_claims_tmp
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM f_populate_dup_orders USING fp_lst_alv_row_dup TYPE zstqtc_alvoutput_r115.

  " Fetch duplicate order data based on selected contract ,L/Item and media issue
  SELECT * FROM zcds_clm_001
    INTO TABLE @DATA(li_do_data)
    WHERE contract = @fp_lst_alv_row_dup-contract         AND
          contract_item = @fp_lst_alv_row_dup-item        AND
          media_issue   = @fp_lst_alv_row_dup-media_issue.
  IF sy-subrc IS INITIAL.
    SORT li_do_data BY contract
                       contract_item
                       media_issue.
    PERFORM f_build_do_output TABLES li_do_data.      " build duplicate order data Popup grid
  ELSE.
    MESSAGE text-m01 TYPE c_infotype.                 " No data for the current selection
  ENDIF.

ENDFORM.

FORM f_build_do_output TABLES fp_li_do_data.

  DATA: li_fieldcat_do  TYPE slis_t_fieldcat_alv,
        lst_fieldcat_do LIKE LINE OF li_fieldcat_do.

  REFRESH : li_fieldcat_do.

  " Build Popup list field catalog
  lst_fieldcat_do-col_pos = 1.
  lst_fieldcat_do-fieldname = 'CONTRACT'.
  lst_fieldcat_do-seltext_l =  text-f19.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  lst_fieldcat_do-col_pos = 2.
  lst_fieldcat_do-fieldname = 'CONTRACT_ITEM'.
  lst_fieldcat_do-seltext_l =  text-f20.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  lst_fieldcat_do-col_pos = 3.
  lst_fieldcat_do-fieldname = 'REL_ORDER'.
  lst_fieldcat_do-seltext_l = text-f61.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  lst_fieldcat_do-col_pos = 4.
  lst_fieldcat_do-fieldname = 'REL_ORD_ITEM'.
  lst_fieldcat_do-seltext_l = text-f62.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  lst_fieldcat_do-col_pos = 5.
  lst_fieldcat_do-fieldname = 'CLAIMS_ORDER'.
  lst_fieldcat_do-seltext_l = text-f82.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  lst_fieldcat_do-col_pos = 6.
  lst_fieldcat_do-fieldname = 'CLAIMS_ITEM'.
  lst_fieldcat_do-seltext_l = text-f83.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  lst_fieldcat_do-col_pos = 7.
  lst_fieldcat_do-fieldname = 'MEDIA_ISSUE'.
  lst_fieldcat_do-seltext_l = text-f02.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  lst_fieldcat_do-col_pos = 8.
  lst_fieldcat_do-fieldname = 'RO_SHIPTO'.
  lst_fieldcat_do-seltext_l = text-d01.
  lst_fieldcat_do-tabname = 'FP_LI_DO_DATA'.
  APPEND lst_fieldcat_do TO li_fieldcat_do.
  CLEAR lst_fieldcat_do.

  " Popup the list with filed names
  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title               = text-010 "'Duplicate Order Details'
      i_zebra               = abap_true
      i_screen_start_column = 20
      i_screen_start_line   = 3
      i_screen_end_column   = 130
      i_screen_end_line     = 20
      i_tabname             = 'FP_LI_DO_DATA'
      it_fieldcat           = li_fieldcat_do
      i_callback_program    = sy-repid
    TABLES
      t_outtab              = fp_li_do_data
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM f_prepare_excel_headers.

  FREE : st_header , i_header .

  st_header-v_head = text-f01.  " Journal
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f02. " Media Issue
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f03.  " Publication date
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f04.  " Actual goods arrival date
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f05.  " Cross Media Issue Plant Status - General
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f06.  " Cross Media Issue Distribution Chain Status - Sales
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f07.  " Media Issue Item Category Group
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f08.  " Distribution Chain Specific Status
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f09.  " Issue Number
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f10.  " Volume/Copy Number
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f11.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f12.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f13.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f14.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f72.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f73.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f15.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f17.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f18.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f74.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f19.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f20.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f75.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f76.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f77.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f78.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f79.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f80.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f81.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f22.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f21.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f29.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f23.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f24.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f25.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f26.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f27.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f28.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f30.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f31.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f32.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f33.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f34.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f35.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f36.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f37.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f38.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f39.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f40.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f41.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f42.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f43.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f44.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f45.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f46.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f47.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f48.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f49.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f50.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f51.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f52.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f53.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f54.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f70.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f71.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f55.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f56.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f58.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f60.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f61.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f62.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r01.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r02.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r03.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r04.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r05.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r06.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r07.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r08.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r09.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r10.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r11.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r12.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-r13.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f59.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f63.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f64.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f65.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f66.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f67.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f68.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f69.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f82.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f83.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c02.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c03.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c04.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c05.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c06.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c07.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c08.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c09.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c10.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c11.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c12.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-c13.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f84.
  APPEND st_header TO i_header.
  CLEAR st_header.

  st_header-v_head = text-f85.
  APPEND st_header TO i_header.
  CLEAR st_header.

ENDFORM.

FORM f_prepare_excel_data .

  DATA : li_excel_dup       TYPE STANDARD TABLE OF zstqtc_excel_output_r115 INITIAL SIZE 0,     " Data declaration for duplicate values
         lv_dup_order_index TYPE sy-tabix.

  " Assign alv output data to tmp table and remove the non dulicate row values.
  DATA(li_tmp_alv_out) = i_alv_output[].
  SORT li_tmp_alv_out BY duplicate_count.
  DELETE li_tmp_alv_out WHERE duplicate_count = 0.

  "Claim order details assign to tmp table
  DATA(li_claim_orders_tmp) = i_claim_orders[].
  SORT li_claim_orders_tmp BY claims_order claims_item media_issue.


  " Fetch release order data for ALV output data
  SELECT * FROM zcds_clm_001
    INTO TABLE @DATA(li_duplicate_data)
    FOR ALL ENTRIES IN @li_tmp_alv_out
    WHERE contract = @li_tmp_alv_out-contract         AND
          contract_item = @li_tmp_alv_out-item        AND
          media_issue   = @li_tmp_alv_out-media_issue.
  IF sy-subrc IS INITIAL.
    SORT li_duplicate_data BY contract
                              contract_item
                              media_issue.
  ENDIF.

  " Fetch release order data for ALV output data
  SELECT release_order,
         release_order_item,
         release_order_type,
         release_order_date,
         release_order_item_categ,
         ro_sch_line_category,
         rel_ord_rejection_date,
         rel_ord_rejection_user,
         ro_del_block,
         rel_ord_delblk_date,
         rel_ord_delblk_user,
         confirmation_status,
         pr_deletion,
         rel_ord_qty,
         rel_ord_del_date
    FROM zcds_relord_r115
    INTO TABLE @DATA(li_release_order)
    FOR ALL ENTRIES IN @i_alv_output
    WHERE release_order = @i_alv_output-release_order     AND
          release_order_item = @i_alv_output-release_order_item.
  IF sy-subrc IS INITIAL.
    SORT li_release_order BY release_order release_order_item.
  ENDIF.

  SORT i_view BY contract item media_issue.

  REFRESH i_excel_output.
  LOOP AT i_alv_output ASSIGNING FIELD-SYMBOL(<lfs_alv_output>).

    " Prepare excel export data tab
    APPEND INITIAL LINE TO i_excel_output ASSIGNING FIELD-SYMBOL(<lfs_excel_output>).

    <lfs_excel_output>-journal       = <lfs_alv_output>-journal.
    <lfs_excel_output>-media_issue   = <lfs_alv_output>-media_issue.

    " Fill master data
    IF i_view IS NOT INITIAL.
      READ TABLE i_view ASSIGNING <fs_view> WITH KEY contract = <lfs_alv_output>-contract
                                                     item     = <lfs_alv_output>-item
                                                     journal  = <lfs_alv_output>-journal
                                                     media_issue = <lfs_alv_output>-media_issue BINARY SEARCH.
      IF sy-subrc = 0.
        IF <fs_view>-publication_date IS NOT INITIAL.
          WRITE <fs_view>-publication_date TO <lfs_excel_output>-publication_date MM/DD/YYYY.
        ENDIF.
        IF <fs_view>-actual_gi_date IS NOT INITIAL.
          WRITE <fs_view>-actual_gi_date TO <lfs_excel_output>-actual_gi_date MM/DD/YYYY.
        ENDIF.
        <lfs_excel_output>-material_status    = <fs_view>-material_status.
        <lfs_excel_output>-distr_chain_status = <fs_view>-distr_chain_status.
        <lfs_excel_output>-mi_ic_group        = <fs_view>-mi_ic_group.
        <lfs_excel_output>-dist_chain_status  = <fs_view>-dist_chain_status.
        <lfs_excel_output>-issue_number       = <fs_view>-issue_number.
        <lfs_excel_output>-vol_copy_no        = <fs_view>-vol_copy_no.
        <lfs_excel_output>-year_number        = <fs_view>-year_number.
        <lfs_excel_output>-publication_type   = <fs_view>-publication_type.
        <lfs_excel_output>-del_plant          = <fs_view>-del_plant.
        <lfs_excel_output>-profit_center      = <fs_view>-profit_center.
        IF <fs_view>-init_ship_date IS NOT INITIAL.
          WRITE <fs_view>-init_ship_date TO <lfs_excel_output>-init_ship_date MM/DD/YYYY.
        ENDIF.
        IF <fs_view>-delivery_date IS NOT INITIAL.
          WRITE <fs_view>-delivery_date TO <lfs_excel_output>-delivery_date MM/DD/YYYY.
        ENDIF.

        <lfs_excel_output>-plan_status_desc   = <fs_view>-plan_status_desc.

        IF <fs_view>-planned_ro_from IS NOT INITIAL.
          WRITE <fs_view>-planned_ro_from TO <lfs_excel_output>-planned_ro_from MM/DD/YYYY.
        ENDIF.
        IF <fs_view>-planned_ro_to IS NOT INITIAL.
          WRITE <fs_view>-planned_ro_to TO <lfs_excel_output>-planned_ro_to MM/DD/YYYY.
        ENDIF.
      ENDIF.
    ENDIF.

    <lfs_excel_output>-assignment           = <lfs_alv_output>-assignment.
    <lfs_excel_output>-contract             = <lfs_alv_output>-contract.
    <lfs_excel_output>-item                 = <lfs_alv_output>-item.
    IF <lfs_alv_output>-contract_created IS NOT INITIAL.
      WRITE <lfs_alv_output>-contract_created TO <lfs_excel_output>-contract_created MM/DD/YYYY.
    ENDIF.
    <lfs_excel_output>-rejection_user       = <lfs_alv_output>-rejection_user.
    <lfs_excel_output>-contract_soldto      = <lfs_alv_output>-contract_soldto.
    <lfs_excel_output>-contract_soldto_name = <lfs_alv_output>-contract_soldto_name.
    <lfs_excel_output>-contract_shipto      = <lfs_alv_output>-contract_shipto.
    <lfs_excel_output>-contract_shipto_name = <lfs_alv_output>-contract_shipto_name.
    <lfs_excel_output>-contract_shipto_ctry = <lfs_alv_output>-contract_shipto_ctry.
    <lfs_excel_output>-contract_reason      = <lfs_alv_output>-contract_reason.
    <lfs_excel_output>-item_category        = <lfs_alv_output>-item_category.
    IF <lfs_alv_output>-contract_start_date IS NOT INITIAL.
      WRITE <lfs_alv_output>-contract_start_date TO <lfs_excel_output>-contract_start_date MM/DD/YYYY.
    ENDIF.
    IF <lfs_alv_output>-contract_end_date IS NOT INITIAL.
      WRITE <lfs_alv_output>-contract_end_date TO <lfs_excel_output>-contract_end_date MM/DD/YYYY.
    ENDIF.
    <lfs_excel_output>-contract_qty         = <lfs_alv_output>-contract_qty.
    <lfs_excel_output>-plant                = <lfs_alv_output>-plant.
    <lfs_excel_output>-mat_grp_5            = <lfs_alv_output>-mat_grp_5.
    <lfs_excel_output>-mat_grp_3            = <lfs_alv_output>-mat_grp_3.
    <lfs_excel_output>-net_value_item       = <lfs_alv_output>-net_value_item.
    <lfs_excel_output>-currency             = <lfs_alv_output>-currency.
    <lfs_excel_output>-billing_block_desc   = <lfs_alv_output>-billing_block_desc.
    <lfs_excel_output>-delivery_block_desc  = <lfs_alv_output>-delivery_block_desc.
    <lfs_excel_output>-overall_status_desc  = <lfs_alv_output>-overall_status_desc.
    <lfs_excel_output>-credit_status_desc   = <lfs_alv_output>-credit_status_desc.
    <lfs_excel_output>-cancel_reason_desc   = <lfs_alv_output>-cancel_reason_desc.
    <lfs_excel_output>-cancelled_orders_desc = <lfs_alv_output>-cancelled_orders_desc.
    <lfs_excel_output>-reason_for_cancel_desc = <lfs_alv_output>-reason_for_cancel_desc.
    IF <lfs_alv_output>-acceptance_date IS NOT INITIAL .
      WRITE <lfs_alv_output>-acceptance_date TO <lfs_excel_output>-acceptance_date MM/DD/YYYY.
    ENDIF.
    IF <lfs_alv_output>-req_cancellation_date IS NOT INITIAL.
      WRITE <lfs_alv_output>-req_cancellation_date TO <lfs_excel_output>-req_cancellation_date MM/DD/YYYY.
    ENDIF.
    <lfs_excel_output>-price_grp_desc       = <lfs_alv_output>-price_grp_desc.
    <lfs_excel_output>-delivery_number      = <lfs_alv_output>-delivery_number.
    <lfs_excel_output>-delivery_item        = <lfs_alv_output>-delivery_item.
    <lfs_excel_output>-mat_doc              = <lfs_alv_output>-mat_doc.
    <lfs_excel_output>-mat_doc_item         = <lfs_alv_output>-mat_doc_item.
    <lfs_excel_output>-mat_doc_type         = <lfs_alv_output>-mat_doc_type.
    <lfs_excel_output>-mat_doc_year         = <lfs_alv_output>-mat_doc_year.
    IF <lfs_alv_output>-mat_doc_date IS NOT INITIAL.
      WRITE <lfs_alv_output>-mat_doc_date TO <lfs_excel_output>-mat_doc_date MM/DD/YYYY.
    ENDIF.
    <lfs_excel_output>-po_number            = <lfs_alv_output>-po_number.
    <lfs_excel_output>-po_item              = <lfs_alv_output>-po_item.
    <lfs_excel_output>-po_type              = <lfs_alv_output>-po_type.
    <lfs_excel_output>-po_del_ind           = <lfs_alv_output>-po_del_ind.
    <lfs_excel_output>-po_info_rec          = <lfs_alv_output>-po_info_rec.
    <lfs_excel_output>-po_qty               = <lfs_alv_output>-po_qty.
    <lfs_excel_output>-vendor               = <lfs_alv_output>-vendor.
    <lfs_excel_output>-vendor_name          = <lfs_alv_output>-vendor_name.
    <lfs_excel_output>-value_per_issue      = <lfs_alv_output>-value_per_issue.
    <lfs_excel_output>-earned_amount        = <lfs_alv_output>-earned_amount.
    <lfs_excel_output>-balance              = <lfs_alv_output>-balance.
    <lfs_excel_output>-release_order_created =   <lfs_alv_output>-release_order_created.
    <lfs_excel_output>-release_order        = <lfs_alv_output>-release_order.
    <lfs_excel_output>-release_order_item   = <lfs_alv_output>-release_order_item.

    " fill release order data
    IF li_release_order IS NOT INITIAL.
      READ TABLE li_release_order ASSIGNING FIELD-SYMBOL(<lfs_release_order>) WITH KEY release_order = <lfs_alv_output>-release_order
                                                                                      release_order_item = <lfs_alv_output>-release_order_item BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_excel_output>-release_order_type       = <lfs_release_order>-release_order_type.
        IF <lfs_release_order>-release_order_date IS NOT INITIAL.
          WRITE <lfs_release_order>-release_order_date TO <lfs_excel_output>-release_order_date MM/DD/YYYY.
        ENDIF.
        <lfs_excel_output>-release_order_item_categ = <lfs_release_order>-release_order_item_categ.
        <lfs_excel_output>-ro_sch_line_category     = <lfs_release_order>-ro_sch_line_category.
        IF <lfs_release_order>-rel_ord_rejection_date IS NOT INITIAL.
          WRITE <lfs_release_order>-rel_ord_rejection_date TO <lfs_excel_output>-rel_ord_rejection_date MM/DD/YYYY.
        ENDIF.
        <lfs_excel_output>-rel_ord_rejection_user   = <lfs_release_order>-rel_ord_rejection_user.
        <lfs_excel_output>-ro_del_block             = <lfs_release_order>-ro_del_block.
        IF <lfs_release_order>-rel_ord_delblk_date IS NOT INITIAL.
          WRITE <lfs_release_order>-rel_ord_delblk_date TO <lfs_excel_output>-rel_ord_delblk_date MM/DD/YYYY.
        ENDIF.
        <lfs_excel_output>-rel_ord_delblk_user      = <lfs_release_order>-rel_ord_delblk_user.
        <lfs_excel_output>-confirmation_status      = <lfs_release_order>-confirmation_status.
        <lfs_excel_output>-pr_deletion              = <lfs_release_order>-pr_deletion.
        <lfs_excel_output>-rel_ord_qty              = <lfs_release_order>-rel_ord_qty.
        IF <lfs_release_order>-rel_ord_del_date IS NOT INITIAL.
          WRITE <lfs_release_order>-rel_ord_del_date TO <lfs_excel_output>-rel_ord_del_date MM/DD/YYYY.
        ENDIF.
      ENDIF.
    ENDIF.

    <lfs_excel_output>-doc_type             = <lfs_alv_output>-doc_type.
    <lfs_excel_output>-document_currency    = <lfs_alv_output>-document_currency.
    <lfs_excel_output>-purchase_requisition = <lfs_alv_output>-purchase_requisition.
    <lfs_excel_output>-purchase_requisition_item = <lfs_alv_output>-purchase_requisition_item.
    <lfs_excel_output>-relevant_rar         = <lfs_alv_output>-relevant_rar.
    <lfs_excel_output>-sales_org            = <lfs_alv_output>-sales_org.
    <lfs_excel_output>-dist_channel         = <lfs_alv_output>-dist_channel.
    <lfs_excel_output>-division             = <lfs_alv_output>-division.
    <lfs_excel_output>-sales_office         = <lfs_alv_output>-sales_office.

    " Fill claim order data
    IF i_claim_orders IS NOT INITIAL.
      READ TABLE i_claim_orders ASSIGNING <gfs_claim_orders> WITH KEY contract      = <lfs_alv_output>-contract
                                                                      contract_item = <lfs_alv_output>-item
                                                                      media_issue   = <lfs_alv_output>-media_issue BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_excel_output>-claims_order         = <gfs_claim_orders>-claims_order.
        <lfs_excel_output>-claims_item          = <gfs_claim_orders>-claims_item.
        <lfs_excel_output>-claim_confirmation_status = <gfs_claim_orders>-confirmation_status.
        <lfs_excel_output>-quantity             = <gfs_claim_orders>-quantity.
        IF <gfs_claim_orders>-created_date IS NOT INITIAL.
          WRITE <gfs_claim_orders>-created_date TO <lfs_excel_output>-created_date MM/DD/YYYY.
        ENDIF.
        <lfs_excel_output>-item_categ           = <gfs_claim_orders>-item_categ.
        <lfs_excel_output>-sch_line_categ       = <gfs_claim_orders>-sch_line_categ.
        <lfs_excel_output>-claim_cancel_reason_desc = <gfs_claim_orders>-cancel_reason_desc.
        IF <gfs_claim_orders>-rejection_date IS NOT INITIAL.
          WRITE <gfs_claim_orders>-rejection_date TO <lfs_excel_output>-rejection_date MM/DD/YYYY.
        ENDIF.
        <lfs_excel_output>-claim_rejection_user = <gfs_claim_orders>-rejection_user.
        <lfs_excel_output>-deliv_block          = <gfs_claim_orders>-deliv_block.
        <lfs_excel_output>-deliv_num            = <gfs_claim_orders>-deliv_num.
        <lfs_excel_output>-deliv_item           = <gfs_claim_orders>-deliv_item.
        <lfs_excel_output>-pgi_doc              = <gfs_claim_orders>-pgi_doc.
      ENDIF.
    ENDIF.

    " Read Duplicate order count
    IF i_dup_orders IS NOT INITIAL.
      READ TABLE i_dup_orders  ASSIGNING FIELD-SYMBOL(<lfs_duplicate_orders>) WITH KEY contract = <lfs_alv_output>-contract
                                                                                       contract_item = <lfs_alv_output>-item
                                                                                       media_issue   = <lfs_alv_output>-media_issue BINARY SEARCH.
      IF sy-subrc = 0.
        <lfs_excel_output>-duplicate_count = <lfs_duplicate_orders>-row_count.
      ENDIF.
    ENDIF.

    <lfs_excel_output>-invoice_number = <lfs_alv_output>-invoice_number.

    " Add duplicate line for excel file by checking the duplicate line count
    IF <lfs_alv_output>-duplicate_count NE 0.
      REFRESH li_excel_dup.
      IF li_duplicate_data IS NOT INITIAL.
        READ TABLE li_duplicate_data ASSIGNING FIELD-SYMBOL(<lfs_duplicate_data>) WITH KEY contract  = <lfs_alv_output>-contract
                                                                                           contract_item = <lfs_alv_output>-item
                                                                                           media_issue   = <lfs_alv_output>-media_issue BINARY SEARCH.
        lv_dup_order_index = sy-tabix.
        " applying pararel cursor method
        LOOP AT li_duplicate_data ASSIGNING <lfs_duplicate_data> FROM lv_dup_order_index.
          IF ( <lfs_alv_output>-contract NE <lfs_duplicate_data>-contract )   OR    " check Contract,L/item,Media issue
             (  <lfs_alv_output>-item NE <lfs_duplicate_data>-contract_item ) OR
             (  <lfs_alv_output>-media_issue NE <lfs_duplicate_data>-media_issue ).
            EXIT.
          ENDIF.

          " Add duplicate line for temporary output
          APPEND INITIAL LINE TO li_excel_dup ASSIGNING FIELD-SYMBOL(<lfs_excel_dup>).
          MOVE-CORRESPONDING <lfs_excel_output> TO <lfs_excel_dup>.
          <lfs_excel_dup>-claims_order = <lfs_duplicate_data>-claims_order.
          <lfs_excel_dup>-claims_item  = <lfs_duplicate_data>-claims_item.


          " Read particular cliam order details
          IF li_claim_orders_tmp IS NOT INITIAL.
            READ TABLE li_claim_orders_tmp ASSIGNING FIELD-SYMBOL(<lfs_claim_orders_tmp>) WITH KEY claims_order  = <lfs_duplicate_data>-claims_order
                                                                                                   claims_item   = <lfs_duplicate_data>-claims_item
                                                                                                   media_issue   = <lfs_duplicate_data>-media_issue BINARY SEARCH.
            IF sy-subrc = 0.
              <lfs_excel_dup>-claim_confirmation_status = <lfs_claim_orders_tmp>-confirmation_status.
              <lfs_excel_dup>-quantity             = <lfs_claim_orders_tmp>-quantity.
              IF <lfs_claim_orders_tmp>-created_date IS NOT INITIAL.
                WRITE <lfs_claim_orders_tmp>-created_date TO <lfs_excel_dup>-created_date MM/DD/YYYY.
              ENDIF.
              <lfs_excel_dup>-item_categ           = <lfs_claim_orders_tmp>-item_categ.
              <lfs_excel_dup>-sch_line_categ       = <lfs_claim_orders_tmp>-sch_line_categ.
              <lfs_excel_dup>-claim_cancel_reason_desc = <lfs_claim_orders_tmp>-cancel_reason_desc.
              IF <lfs_claim_orders_tmp>-rejection_date IS NOT INITIAL.
                WRITE <lfs_claim_orders_tmp>-rejection_date TO <lfs_excel_dup>-rejection_date MM/DD/YYYY.
              ENDIF.
              <lfs_excel_dup>-claim_rejection_user = <lfs_claim_orders_tmp>-rejection_user.
              <lfs_excel_dup>-deliv_block          = <lfs_claim_orders_tmp>-deliv_block.
              <lfs_excel_dup>-deliv_num            = <lfs_claim_orders_tmp>-deliv_num.
              <lfs_excel_dup>-deliv_item           = <lfs_claim_orders_tmp>-deliv_item.
              <lfs_excel_dup>-pgi_doc              = <lfs_claim_orders_tmp>-pgi_doc.
            ENDIF.
          ENDIF.
        ENDLOOP.

        " add duplicate lines to final excel output table
        APPEND LINES OF li_excel_dup TO i_excel_output.
      ENDIF.
    ENDIF.

  ENDLOOP.

  SORT i_excel_output.
  DELETE ADJACENT DUPLICATES FROM i_excel_output COMPARING ALL FIELDS.

ENDFORM.

FORM f_download_excel .

  DATA : lv_fname TYPE string,  " File name
         lv_path  TYPE string,  " File path
         lv_fpath TYPE string.  " full path(File name + File path)

* To save the file dialog
  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      default_extension         = 'XLS'
    CHANGING
      filename                  = lv_fname
      path                      = lv_path
      fullpath                  = lv_fpath
    EXCEPTIONS
      cntl_error                = 1
      error_no_gui              = 2
      not_supported_by_gui      = 3
      invalid_default_file_name = 4
      OTHERS                    = 5.
  IF sy-subrc = 0.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename                = lv_fpath
        filetype                = 'ASC'
        write_field_separator   = '|'
        header                  = '00'
        wk1_t_size              = 15
        confirm_overwrite       = 'X'
      TABLES
        data_tab                = i_excel_output[]
        fieldnames              = i_header
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        OTHERS                  = 22.
    IF sy-subrc <> 0.
      " need to implement suitable error handler
    ENDIF.

  ENDIF.
ENDFORM.

FORM f_get_constant_values.

  SELECT devid,                      "Development ID
         param1,                     "ABAP: Name of Variant Variable
         param2,                    "ABAP: Name of Variant Variable
         srno,                       "Current selection number
         sign,                       "ABAP: ID: I/E (include/exclude values)
         opti,                       "ABAP: Selection option (EQ/BT/CP/...)
         low,                        "Lower Value of Selection Condition
         high,                       "Upper Value of Selection Condition
         activate                   "Activation indicator for constant
         FROM zcaconstant           " Wiley Application Constant Table
         INTO TABLE @i_constant
         WHERE devid    = @c_devid
         AND   activate = @abap_true.       "Only active record
  IF sy-subrc IS INITIAL.
    SORT i_constant BY param1.
  ENDIF.

ENDFORM.

FORM f_populate_defaults .

  " Read default layout from the constant table
  READ TABLE i_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>) WITH KEY param1 = c_layout BINARY SEARCH.
  IF sy-subrc = 0.
    p_alv_vr = <lfs_constant>-low.
  ENDIF.

* BOC by Lahiru on 04/07/2021 for OTCM-29592 with ED2K922941  *
  " Read default row count for foreground processing
  READ TABLE i_constant ASSIGNING <lfs_constant> WITH KEY param1 = c_rowcount BINARY SEARCH.
  IF sy-subrc = 0.
    v_rowcount = <lfs_constant>-low.
  ENDIF.
* EOC by Lahiru on 04/07/2021 for OTCM-29592 with ED2K922941  *

* BOC by Lahiru on 04/12/2021 for OTCM-29592 with ED2K922993 *
  " Read default row count for foreground processing
  READ TABLE i_constant ASSIGNING <lfs_constant> WITH KEY param1 = c_rowcount_bg BINARY SEARCH.
  IF sy-subrc = 0.
    v_rowcount_bg = <lfs_constant>-low.
  ENDIF.
* EOC by Lahiru on 04/12/2021 for OTCM-29592 with ED2K922993 *

ENDFORM.

FORM f_create_bg_process .

  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_user       TYPE sy-uname,         " User Name
        lv_pre_chk    TYPE btcckstat.        " variable for pre. job status

  CONSTANTS : lc_job_name   TYPE btcjob VALUE 'MEDIA_ISSUE_COCKPIT_R115'. " Background job name

**** Submit Program
  CLEAR : lv_job_name , lv_job_number , v_receiver.
  CONCATENATE lc_job_name '_' sy-datum '_' sy-uzeit '_' sy-uname  INTO lv_job_name.
  v_receiver = sy-uname.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc = 0.
    SUBMIT zqtcr_media_issue_r115_poc  WITH rb_fgr = rb_fgr
                                      WITH rb_bgr = rb_bgr
                                      WITH s_prod IN s_prod
                                      WITH s_issu IN s_issu
                                      WITH s_pbdt IN s_pbdt
                                      WITH s_pbdt IN s_pbdt
                                      WITH s_dldt IN s_dldt
                                      WITH s_gddt IN s_gddt
                                      WITH s_sorg IN s_sorg
                                      WITH s_dist IN s_dist
                                      WITH s_sdiv IN s_sdiv
                                      WITH s_soff IN s_soff
                                      WITH s_sdoc IN s_sdoc
                                      WITH s_assg IN s_assg
                                      WITH s_dctp IN s_dctp
                                      WITH s_dctp IN s_dctp
                                      WITH s_csdt IN s_csdt
                                      WITH s_cedt IN s_cedt
                                      WITH s_rele IN s_rele
                                      WITH s_iamt EQ c_iamt
                                      WITH s_exbb EQ c_exbb
                                      WITH s_exdb EQ c_exdb
                                      WITH s_excb EQ c_excb
                                      WITH s_excc EQ c_excc
                                      WITH s_exro EQ c_exro
                                      WITH s_irel EQ c_irel
                                      WITH p_alv_vr =  p_alv_vr
                                      WITH p_userid = sy-uname
                                      USER  'QTC_BATCH01'
                                      VIA JOB lv_job_name
                                      NUMBER lv_job_number AND RETURN.

    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobname              = lv_job_name
        jobcount             = lv_job_number
        predjob_checkstat    = lv_pre_chk
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 08.
    IF sy-subrc = 0.

    ENDIF. " IF sy-subrc = 0
  ENDIF.

ENDFORM.

FORM f_generate_bg_file .

  " Build final internal table for excel processing
  PERFORM f_prepare_excel_data.

  PERFORM f_set_text_elements.              " Set excel properties
  PERFORM f_create_workbook.                " Create Workbook and Porperties

  " Style
  v_styles = v_document->create_simple_element( name = v_xlstyles  parent = v_element_root  ).

  " Build style for header
  PERFORM f_style_for_header.               " Style for header Columns
  PERFORM f_style_for_lineitem.             " Style for detail Data
  PERFORM f_style_for_numbers.              " Style for numbers

  PERFORM f_create_sheet USING v_docname.    " Create excel worksheet.
  PERFORM f_build_table.                     " Build a Table
  PERFORM f_column_formatting.               " Format excel columns
  PERFORM f_header_row_format.               " Header Column formatting
  PERFORM f_header_columns.                  " Build header Columns names
  PERFORM f_fill_data.                       " Fill data to the excel
  PERFORM f_generate_xml_file.               " Generate XML file

ENDFORM.

FORM f_set_text_elements.

  v_workbook = text-e01.  "'Workbook'
  v_xmlns    = text-e02.  "'xmlns'
  v_urn      = text-e03.  "'urn:schemas-microsoft-com:office:spreadsheet'.
  v_ss       = text-e04.  " ss
  v_xx       = text-e05.  " X
  v_urn1     = text-e06.  " urn:schemas-microsoft-com:office:excel
  v_docname  = text-e07.  " Media_Issue_Cockpit_Report
  v_author   = text-e08.  " Author
  v_xlstyles = text-e09.  " Styles
  v_xlstyle  = text-e10.  " Style
  v_id       = text-e11.  " ID
  v_header   = text-e12.  " Header
  v_font     = text-e13.  " Font
  v_bold     = text-e14.  " Bold
  v_color    = text-e15.  " Color
  v_interior = text-e16.  " Color
  v_pattern  = text-e17.  " Pattern
  v_solid    = text-e18.  " Solid
  v_alignment = text-e19. " Alignment
  v_horizontal = text-e20." Horizontal
  v_vertical  = text-e21. " Vertical
  v_center    = text-e22. " Center
  v_left      = text-e23. " Left
  v_xldata    = text-e24. " Data
  v_xlworksheet    = text-e25.  " Worksheet
  v_name      = text-e26. " Name
  v_xltable  = text-e27.  "Table
  v_fullcolumns = text-e28. " FullColumns
  v_fullrows    = text-e29. " FullRows
  v_xlcolumn    = text-e30. " Column
  v_width       = text-e31. " Width
  v_xlrow       = text-e32. " Row
  v_height      = text-e33. " Height
  v_xlcell      = text-e34. " Cell
  v_styleid     = text-e35. " StyleID
  v_xltype      = text-e36. " Type
  v_string      = text-e37. " String
  v_xldata1     = text-e38. " Normal
  v_numberformat = text-e39." NumberFormat
  v_xlformat     = text-e40." Format

ENDFORM.


FORM f_create_workbook .

  DATA : lv_user TYPE string.
  lv_user = p_userid.

* Creating a ixml Factory
  v_ixml = cl_ixml=>create( ).

* Creating the DOM Object Model
  v_document = v_ixml->create_document( ).

* Create Root Node 'Workbook'
  v_element_root  = v_document->create_simple_element( name = v_workbook  parent = v_document ).
  v_element_root->set_attribute( name = v_xmlns  value = v_urn ).

  v_attribute = v_document->create_namespace_decl( name = v_ss  prefix = v_xmlns  uri = v_urn ).
  v_element_root->set_attribute_node( v_attribute ).

  v_attribute = v_document->create_namespace_decl( name = v_xx  prefix = v_xmlns  uri = v_urn1 ).
  v_element_root->set_attribute_node( v_attribute ).

* Create node for document properties.
  v_element_properties = v_document->create_simple_element( name = v_docname  parent = v_element_root ).
  v_value = lv_user.
  v_document->create_simple_element( name = v_author  value = v_value  parent = v_element_properties  ).

ENDFORM.

FORM f_style_for_header .

  v_style  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles ).
  v_style->set_attribute_ns( name = v_id  prefix = v_ss  value = v_header ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '0' ).
  v_format->set_attribute_ns( name = v_color  prefix = v_ss  value = '#000000' ).

  v_format  = v_document->create_simple_element( name = v_alignment  parent = v_style ).
  v_format->set_attribute_ns( name = v_vertical  prefix = v_ss  value = v_center ).
  v_format->set_attribute_ns( name = v_horizontal  prefix = v_ss  value = v_left ).

ENDFORM.

FORM f_style_for_lineitem .

  v_style1  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_xldata ).

  v_format  = v_document->create_simple_element( name = v_font  parent = v_style1  ).
  v_format->set_attribute_ns( name = v_bold  prefix = v_ss  value = '0' ).

ENDFORM.

FORM f_create_sheet USING  fp_docname TYPE string.

  " Worksheet
  v_worksheet = v_document->create_simple_element( name = v_xlworksheet  parent = v_element_root ).
  v_worksheet->set_attribute_ns( name = v_name  prefix = v_ss  value = fp_docname ).

ENDFORM.

FORM f_build_table .

  v_table = v_document->create_simple_element( name = v_xltable  parent = v_worksheet ).
  v_table->set_attribute_ns( name = v_fullcolumns  prefix = v_xx  value = '1' ).
  v_table->set_attribute_ns( name = v_fullrows     prefix = v_xx  value = '1' ).

ENDFORM.

FORM f_column_formatting .

  " Media Product
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Media Issue
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Original Publication Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Actual Goods Arrival Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Cross Media Issue Plant Status
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Cross Media Issue Distr. Chain Status
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Media Issue Item Category Group
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Distr. Chain Specific Status
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Issue Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Volume/Copy Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Year
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Publication Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Delivering Plant
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Profit Center
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Initial Shipping Date (Revised Pub. Date)
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Delivery Date (JKSENIP)
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Shipping Schedule Status
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Planned Rel. Order Creation Date From
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Planned Rel. Order Creation Date To
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Assignment
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Creation date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract  Rejection user
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Sold-to Party
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Sold-to Name
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '200' ).

  " Contract Ship-to Party
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Ship-to Name
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '200' ).

  " Contract Ship to Country
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Reason
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Item Category
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Start Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract End Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Plant
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Material Group 5
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Material Group 3
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Net Value (Item)
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Currency
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Billing Block
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Delivery Block
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Overall Contract Status
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Credit Status
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Rejection Reason
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Contract Cancellation
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Cancellation Reason
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Acceptance Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Requested Cancellation Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Price Group
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Delivery Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Delivery Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Material Doc Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Material Doc Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Material Doc Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Material Doc Year
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Material Doc Posting Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " PO Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " PO Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " PO Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " PO Deletion Indicator
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Purchasing Info Record
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " PO Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Vendor
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Vendor Name
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '200' ).

  " Single Issue Value
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Earned Amount
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Balance Amount
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Created
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Type
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Creation Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Item Category
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Schedule Line Category
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Rejection Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Rejection User
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Delivery Block  With Description
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Delivery Block Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Delivery Block User
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Confirmation Status of Release Order
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " PR Deletion
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Release Order Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Delivery Created Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Document Currency
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Purchase Requistion
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Purchase Requistion Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Relevant for RAR
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Sales Organization
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Distribution Channel
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Division
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Sales office
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Confirmation Status
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Quantity
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Created Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Item Category
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Schedule Line Category
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Reject  with Discription
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Rejection Date
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Rejection User
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Order Delivery Block  With Description
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Delivery Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim Delivery Item
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Claim PGI Document
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Duplicate order count
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

  " Invoice Number
  v_column = v_document->create_simple_element( name =  v_xlcolumn  parent = v_table ).
  v_column->set_attribute_ns( name = v_width  prefix = v_ss  value = '120' ).

ENDFORM.

FORM f_header_row_format .

  v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).
  v_row->set_attribute_ns( name = v_height  prefix = v_ss  value = '20' ).

ENDFORM.

FORM f_header_columns.

  " Build Header Text
  PERFORM f_build_header_names USING text-f01.  "'Media Product
  PERFORM f_build_header_names USING text-f02.  "'Media Issue
  PERFORM f_build_header_names USING text-f03.  "'Original Publication Date
  PERFORM f_build_header_names USING text-f04.  "'Actual Goods Arrival Date
  PERFORM f_build_header_names USING text-f05.  "'Cross Media Issue Plant Status
  PERFORM f_build_header_names USING text-f06.  "'Cross Media Issue Distr. Chain Status
  PERFORM f_build_header_names USING text-f07.  "'Media Issue Item Category Group
  PERFORM f_build_header_names USING text-f08.  "'Distr. Chain Specific Status
  PERFORM f_build_header_names USING text-f09.  "'Issue Number
  PERFORM f_build_header_names USING text-f10.  "'Volume/Copy Number
  PERFORM f_build_header_names USING text-f11.  "'Year
  PERFORM f_build_header_names USING text-f12.  "'Publication Type
  PERFORM f_build_header_names USING text-f13.  "'Delivering Plant
  PERFORM f_build_header_names USING text-f14.  "'Profit Center
  PERFORM f_build_header_names USING text-f72.  "'Initial Shipping Date (Revised Pub. Date)
  PERFORM f_build_header_names USING text-f73.  "'Delivery Date (JKSENIP)
  PERFORM f_build_header_names USING text-f15.  "'Shipping Schedule Status
  PERFORM f_build_header_names USING text-f17.  "'Planned Rel. Order Creation Date From
  PERFORM f_build_header_names USING text-f18.  "'Planned Rel. Order Creation Date To
  PERFORM f_build_header_names USING text-f74.  "'Assignment
  PERFORM f_build_header_names USING text-f19.  "'Contract Number
  PERFORM f_build_header_names USING text-f20.  "'Contract Item
  PERFORM f_build_header_names USING text-f75.  "'Contract Creation date
  PERFORM f_build_header_names USING text-f76.  "'Contract  Rejection user
  PERFORM f_build_header_names USING text-f77.  "'Contract Sold-to Party
  PERFORM f_build_header_names USING text-f78.  "'Contract Sold-to Name
  PERFORM f_build_header_names USING text-f79.  "'Contract Ship-to Party
  PERFORM f_build_header_names USING text-f80.  "'Contract Ship-to Name
  PERFORM f_build_header_names USING text-f81.  "'Contract Ship to Country
  PERFORM f_build_header_names USING text-f22.  "'Contract Reason
  PERFORM f_build_header_names USING text-f21.  "'Contract Type
  PERFORM f_build_header_names USING text-f29.  "'Item Category
  PERFORM f_build_header_names USING text-f23.  "'Contract Start Date
  PERFORM f_build_header_names USING text-f24.  "'Contract End Date
  PERFORM f_build_header_names USING text-f25.  "'Contract Quantity
  PERFORM f_build_header_names USING text-f26.  "'Contract Plant
  PERFORM f_build_header_names USING text-f27.  "'Material Group 5
  PERFORM f_build_header_names USING text-f28.  "'Material Group 3
  PERFORM f_build_header_names USING text-f30.  "'Net Value (Item)
  PERFORM f_build_header_names USING text-f31.  "'Currency
  PERFORM f_build_header_names USING text-f32.  "'Billing Block
  PERFORM f_build_header_names USING text-f33.  "'Delivery Block
  PERFORM f_build_header_names USING text-f34.  "'Overall Contract Status
  PERFORM f_build_header_names USING text-f35.  "'Credit Status
  PERFORM f_build_header_names USING text-f36.  "'Rejection Reason
  PERFORM f_build_header_names USING text-f37.  "'Contract Cancellation
  PERFORM f_build_header_names USING text-f38.  "'Cancellation Reason
  PERFORM f_build_header_names USING text-f39.  "'Acceptance Date
  PERFORM f_build_header_names USING text-f40.  "'Requested Cancellation Date
  PERFORM f_build_header_names USING text-f41.  "'Price Group
  PERFORM f_build_header_names USING text-f42.  "'Delivery Number
  PERFORM f_build_header_names USING text-f43.  "'Delivery Item
  PERFORM f_build_header_names USING text-f44.  "'Material Doc Number
  PERFORM f_build_header_names USING text-f45.  "'Material Doc Item
  PERFORM f_build_header_names USING text-f46.  "'Material Doc Type
  PERFORM f_build_header_names USING text-f47.  "'Material Doc Year
  PERFORM f_build_header_names USING text-f48.  "'Material Doc Posting Date
  PERFORM f_build_header_names USING text-f49.  "'PO Number
  PERFORM f_build_header_names USING text-f50.  "'PO Item
  PERFORM f_build_header_names USING text-f51.  "'PO Type
  PERFORM f_build_header_names USING text-f52.  "'PO Deletion Indicator
  PERFORM f_build_header_names USING text-f53.  "'Purchasing Info Record
  PERFORM f_build_header_names USING text-f54.  "'PO Quantity
  PERFORM f_build_header_names USING text-f70.  "'Vendor
  PERFORM f_build_header_names USING text-f71.  "'Vendor Name
  PERFORM f_build_header_names USING text-f55.  "'Single Issue Value
  PERFORM f_build_header_names USING text-f56.  "'Earned Amount
  PERFORM f_build_header_names USING text-f58.  "'Balance Amount
  PERFORM f_build_header_names USING text-f60.  "'Release Order Created
  PERFORM f_build_header_names USING text-f61.  "'Release Order Number
  PERFORM f_build_header_names USING text-f62.  "'Release Order Item
  PERFORM f_build_header_names USING text-r01.  "'Release Order Type
  PERFORM f_build_header_names USING text-r02.  "'Release Order Creation Date
  PERFORM f_build_header_names USING text-r03.  "'Release Order Item Category
  PERFORM f_build_header_names USING text-r04.  "'Schedule Line Category
  PERFORM f_build_header_names USING text-r05.  "'Release Order Rejection Date
  PERFORM f_build_header_names USING text-r06.  "'PRelease Order Rejection User
  PERFORM f_build_header_names USING text-r07.  "'Release Order Delivery Block  With Description
  PERFORM f_build_header_names USING text-r08.  "'Release Order Delivery Block Date
  PERFORM f_build_header_names USING text-r09.  "'Release Order Delivery Block User
  PERFORM f_build_header_names USING text-r10.  "'Confirmation Status of Release Order
  PERFORM f_build_header_names USING text-r11.  "'PR Deletion
  PERFORM f_build_header_names USING text-r12.  "'Release Order Quantity
  PERFORM f_build_header_names USING text-r13.  "'Delivery Created Date
  PERFORM f_build_header_names USING text-f59.  "'Document Currency
  PERFORM f_build_header_names USING text-f63.  "'Purchase Requistion
  PERFORM f_build_header_names USING text-f64.  "'RPurchase Requistion Item
  PERFORM f_build_header_names USING text-f65.  "'Relevant for RAR
  PERFORM f_build_header_names USING text-f66.  "'Sales Organization
  PERFORM f_build_header_names USING text-f67.  "'Distribution Channel
  PERFORM f_build_header_names USING text-f68.  "'Division
  PERFORM f_build_header_names USING text-f69.  "'Sales office
  PERFORM f_build_header_names USING text-f82.  "'Claim Order Number
  PERFORM f_build_header_names USING text-f83.  "'Claim Order Item
  PERFORM f_build_header_names USING text-c02.  "'Claim Order Confirmation Status
  PERFORM f_build_header_names USING text-c03.  "'Claim Order Quantity
  PERFORM f_build_header_names USING text-c04.  "'Claim Order Created Date
  PERFORM f_build_header_names USING text-c05.  "'Claim Item Category
  PERFORM f_build_header_names USING text-c06.  "'Schedule Line Category
  PERFORM f_build_header_names USING text-c07.  "'Claim Order Reject  with Discription
  PERFORM f_build_header_names USING text-c08.  "'Claim Order Rejection Date
  PERFORM f_build_header_names USING text-c09.  "'Claim Order Rejection User
  PERFORM f_build_header_names USING text-c10.  "'Claim Order Delivery Block  With Description
  PERFORM f_build_header_names USING text-c11.  "'Claim Delivery Number
  PERFORM f_build_header_names USING text-c12.  "'Claim Delivery Item
  PERFORM f_build_header_names USING text-c13.  "'Claim PGI Document
  PERFORM f_build_header_names USING text-f84.  "'Duplicate order count
  PERFORM f_build_header_names USING text-f85.  "'Invoice Number

ENDFORM.

FORM f_build_header_names  USING fp_text TYPE string.

  v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
  v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_header ).
  v_data = v_document->create_simple_element( name = v_xldata  value = fp_text  parent = v_cell ).
  v_data->set_attribute_ns( name = v_xltype  prefix = v_ss value = v_string ).


ENDFORM.

FORM f_fill_data .

  DATA  : lv_quantity TYPE char16.
  CONSTANTS : lc_item   TYPE posnr_nach VALUE '000000',
              lc_matdoc TYPE mjahr VALUE '0000',
              lc_item2  TYPE bnfpo VALUE '00000',
              lc_qty    TYPE bstmg VALUE '0.000'.

  LOOP AT i_excel_output ASSIGNING FIELD-SYMBOL(<lfs_fill_data>).

    v_row = v_document->create_simple_element( name = v_xlrow  parent = v_table ).

    " Media Product
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-journal.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Media Issue
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-media_issue.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Original Publication Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-publication_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Actual Goods Arrival Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-actual_gi_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Cross Media Issue Plant Status
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-material_status.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Cross Media Issue Distr. Chain Status
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-distr_chain_status.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Media Issue Item Category Group
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mi_ic_group.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Distr. Chain Specific Status
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-dist_chain_status.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Issue Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-issue_number.
    SHIFT v_value LEFT DELETING LEADING '0'.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Volume/Copy Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-vol_copy_no.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Year
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-year_number.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Publication Type
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-publication_type.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Delivering Plant
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-del_plant.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Profit Center
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-profit_center.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Initial Shipping Date (Revised Pub. Date)
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-init_ship_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Delivery Date (JKSENIP)
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-delivery_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Shipping Schedule Status
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-plan_status_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    "Planned Rel. Order Creation Date From
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-planned_ro_from.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Planned Rel. Order Creation Date To
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-planned_ro_to.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Assignment
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata1 ).
    v_value = <lfs_fill_data>-assignment.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-item.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Creation date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_created.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    "
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rejection_user.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Sold-to Party
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_soldto.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Sold-to Name
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_soldto_name.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Ship-to Party
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_shipto.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Ship-to Name
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_shipto_name.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Ship to Country
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_shipto_ctry.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Reason
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_reason.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    "Contract Document type
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-doc_type.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Item Category
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-item_category.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Start Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_start_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract End Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-contract_end_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Quantity
    CLEAR lv_quantity.
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    WRITE <lfs_fill_data>-contract_qty TO lv_quantity DECIMALS 0.
    v_value = lv_quantity.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Plant
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-plant.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Material Group 5
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mat_grp_5.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Material Group 3
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mat_grp_3.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Net Value (Item)
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-net_value_item.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Currency
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-currency.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Billing Block
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-billing_block_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Delivery Block
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-delivery_block_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Overall Contract Status
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-overall_status_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Credit Status
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-credit_status_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Rejection Reason
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-cancel_reason_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Contract Cancellation
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-cancelled_orders_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Cancellation Reason
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-reason_for_cancel_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Acceptance Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-acceptance_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Requested Cancellation Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-req_cancellation_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Price Group
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-price_grp_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Delivery Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-delivery_number.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Delivery Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-delivery_item.
    CONDENSE v_value NO-GAPS.
    " Clear default value '000000'
    IF v_value = lc_item.
      CLEAR v_value.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Material Doc Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mat_doc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Material Doc Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mat_doc_item.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Material Doc Type
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mat_doc_type.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Material Doc Year
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mat_doc_year.
    CONDENSE v_value NO-GAPS.
    " Clear default value '0000'
    IF v_value = lc_matdoc.
      CLEAR v_value.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Material Doc Posting Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-mat_doc_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " PO Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-po_number.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " PO Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-po_item.
    CONDENSE v_value NO-GAPS.
    " Clear default value '000000'
    IF v_value = lc_item.
      CLEAR v_value.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " PO Type
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-po_type.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " PO Deletion Indicator
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-po_del_ind.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Purchasing Info Record
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-po_info_rec.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " PO Quantity
    CLEAR lv_quantity.
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-po_qty.
    CONDENSE v_value NO-GAPS.
    " Clear default value '000000'
    IF v_value = lc_qty.
      CLEAR v_value.
    ELSE.
      WRITE <lfs_fill_data>-po_qty TO lv_quantity DECIMALS 0.
      v_value = lv_quantity.
      CONDENSE v_value NO-GAPS.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Vendor
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-vendor.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Vendor Name
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-vendor_name.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Single Issue Value
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-value_per_issue.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Earned Amount
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-earned_amount.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Balance Amount
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-balance.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Created
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-release_order_created.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-release_order.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-release_order_item.
    CONDENSE v_value NO-GAPS.
    " Clear default value '000000'
    IF v_value = lc_item.
      CLEAR v_value.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Type
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-release_order_type.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Creation Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-release_order_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Item Category
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-release_order_item_categ.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Schedule Line Category
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-ro_sch_line_category.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Rejection Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rel_ord_rejection_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Rejection User
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rel_ord_rejection_user.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Delivery Block  With Description
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-ro_del_block.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Delivery Block Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rel_ord_delblk_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Delivery Block User
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rel_ord_delblk_user.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Confirmation Status of Release Order
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-confirmation_status.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " PR Deletion
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-pr_deletion.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Release Order Quantity
    CLEAR lv_quantity.
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rel_ord_qty.
    CONDENSE v_value NO-GAPS.
    " Clear default value '0.000'
    IF v_value = lc_qty.
      CLEAR v_value.
    ELSE.
      WRITE <lfs_fill_data>-rel_ord_qty TO lv_quantity DECIMALS 0.
      v_value = lv_quantity.
      CONDENSE v_value NO-GAPS.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Delivery Created Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rel_ord_del_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Document Currency
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-document_currency.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Purchase Requistion
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-purchase_requisition.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Purchase Requistion Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-purchase_requisition_item.
    CONDENSE v_value NO-GAPS.
    " Clear default value '00000'
    IF v_value = lc_item2.
      CLEAR v_value.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Relevant for RAR
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-relevant_rar.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Sales Organization
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-sales_org.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Distribution Channel
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-dist_channel.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Division
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-division.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Sales office
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-sales_office.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-claims_order.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-claims_item.
    CONDENSE v_value NO-GAPS.
    " Clear default value '000000'
    IF v_value = lc_item.
      CLEAR v_value.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Confirmation Status
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-claim_confirmation_status.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Quantity
    CLEAR lv_quantity.
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-quantity.
    CONDENSE v_value NO-GAPS.
    " Clear default value '0.000'
    IF v_value = lc_qty.
      CLEAR v_value.
    ELSE.
      WRITE <lfs_fill_data>-quantity TO lv_quantity DECIMALS 0.
      v_value = lv_quantity.
      CONDENSE v_value NO-GAPS.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Created Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-created_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Item Category
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-item_categ.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Schedule Line Category
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-sch_line_categ.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Reject  with Discription
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-claim_cancel_reason_desc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Rejection Date
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-rejection_date.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Rejection User
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-claim_rejection_user.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Order Delivery Block  With Description
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-deliv_block.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Delivery Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-deliv_num.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim Delivery Item
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-deliv_item.
    CONDENSE v_value NO-GAPS.
    " Clear default value '000000'
    IF v_value = lc_item.
      CLEAR v_value.
    ENDIF.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Claim PGI Document
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-pgi_doc.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Duplicate order count
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-duplicate_count.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

    " Invoice Number
    v_cell = v_document->create_simple_element( name = v_xlcell  parent = v_row ).
    v_cell->set_attribute_ns( name = v_styleid  prefix = v_ss  value = v_xldata ).
    v_value = <lfs_fill_data>-invoice_number.
    CONDENSE v_value NO-GAPS.
    v_data = v_document->create_simple_element( name = v_xldata  value = v_value   parent = v_cell ).
    v_data->set_attribute_ns( name = v_xltype  prefix = v_ss  value = v_string ).

  ENDLOOP.

ENDFORM.

FORM f_generate_xml_file.

* Creating a Stream Factory
  v_streamfactory = v_ixml->create_stream_factory( ).

* Connect Internal XML Table to Stream Factory
  v_ostream = v_streamfactory->create_ostream_itable( table = i_xml_table ).

* Rendering the Document
  v_renderer = v_ixml->create_renderer( ostream  = v_ostream  document = v_document ).
  v_rc = v_renderer->render( ).

* Saving the XML Document
  v_xml_size = v_ostream->get_num_written_raw( ).


ENDFORM.

FORM f_get_email .

  " Data declaration for Receiver Email address and BAPI
  DATA : ls_addr TYPE bapiaddr3.
  DATA : li_return TYPE TABLE OF bapiret2.

  FIELD-SYMBOLS : <lfs_const> TYPE ty_constant.

  CONSTANTS : lc_email   TYPE rvari_vnam VALUE 'E_MAIL'.

  FREE : v_sender , v_receiver.
  " Get Sender email adress
  IF i_constant IS NOT INITIAL.
    READ TABLE i_constant ASSIGNING <lfs_const> WITH KEY param1 = lc_email BINARY SEARCH.
    IF sy-subrc = 0.
      v_sender = <lfs_const>-low.      " Set Sender email address
    ENDIF.
  ENDIF.

  v_recname = p_userid.         " GUI username

  "Get recevier email adress.
  CALL FUNCTION 'BAPI_USER_GET_DETAIL'
    EXPORTING
      username = v_recname
    IMPORTING
      address  = ls_addr
    TABLES
      return   = li_return.

  "Check return table values
  IF li_return IS NOT INITIAL.
    SORT li_return BY type.
    READ TABLE li_return ASSIGNING FIELD-SYMBOL(<lfs_return>) WITH KEY type = c_errtype BINARY SEARCH..
    IF sy-subrc = 0.
      MESSAGE <lfs_return>-message TYPE c_errtype.
      UNASSIGN <lfs_return>.
    ENDIF.
  ENDIF.

  " Set receiver email address
  v_receiver = ls_addr-e_mail.
  FREE ls_addr.

ENDFORM.

FORM f_send_mail .

  DATA: li_objpack  TYPE STANDARD TABLE OF sopcklsti1,
        lst_objpack TYPE sopcklsti1.

  DATA: li_objhead  TYPE STANDARD TABLE OF solisti1,
        lst_objhead TYPE solisti1.

  DATA: li_objbin  TYPE STANDARD TABLE OF solix,
        lst_objbin TYPE solix.

  DATA: li_objtxt  TYPE STANDARD TABLE OF solisti1,
        lst_objtxt TYPE solisti1.

  DATA: li_reclist  TYPE STANDARD TABLE OF somlreci1,
        lst_reclist TYPE somlreci1.

  DATA: lv_doc_chng  TYPE sodocchgi1.
  DATA: lv_tab_lines TYPE sy-tabix.

  DATA : lv_date TYPE sy-datum,
         lv_time TYPE sy-uzeit.

  CONSTANTS : lc_x(1)    TYPE c VALUE 'X',
              lc_addtype TYPE soextreci1-adr_typ VALUE 'INT'.

  lv_date = sy-datum.       " System date
  lv_time = sy-uzeit.       " System time

* Mail Subject
  CONCATENATE text-b01 lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lv_doc_chng-obj_descr. "Media Issue Cockpit report_
  CONCATENATE lv_doc_chng-obj_descr '_' lv_time INTO lv_doc_chng-obj_descr.

* Mail Contents
  lst_objtxt = text-b02."'Dear User,'.
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  " Mail Contents
  lst_objtxt = text-b03."'Please find the attached JAPT Detail Report.'.
  APPEND lst_objtxt TO li_objtxt.

  CLEAR lst_objtxt.
  APPEND lst_objtxt TO li_objtxt.

  lst_objtxt = text-b04."'This is a system genarated email – please do not reply to it.'.
  APPEND lst_objtxt TO li_objtxt.


  DESCRIBE TABLE li_objtxt LINES lv_tab_lines.
  READ TABLE li_objtxt INTO lst_objtxt INDEX lv_tab_lines.
  lv_doc_chng-doc_size = ( lv_tab_lines - 1 ) * 255 + strlen( lst_objtxt ).

* Packing List For the E-mail Body
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num   = lv_tab_lines.
  lst_objpack-doc_type   = 'RAW'.
  APPEND lst_objpack TO li_objpack.

* Creation of the Document Attachment
  LOOP AT i_xml_table ASSIGNING <gfs_xml>.
    CLEAR lst_objbin.
    lst_objbin-line = <gfs_xml>-data.
    APPEND lst_objbin TO li_objbin.
  ENDLOOP.

  DESCRIBE TABLE li_objbin LINES lv_tab_lines.
  lst_objhead = text-b05."'Media_Issue_Cockpit_Report
  APPEND lst_objhead TO li_objhead.

* Packing List For the E-mail Attachment
  lst_objpack-transf_bin = lc_x.
  lst_objpack-head_start = 1.
  lst_objpack-head_num   = 0.
  lst_objpack-body_start = 1.
  lst_objpack-body_num = lv_tab_lines.
  CONCATENATE text-b01 lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lst_objpack-obj_descr.   "Media Issue Cockpit Report_
  CONCATENATE lst_objpack-obj_descr '_' lv_time INTO lst_objpack-obj_descr.
  lst_objpack-doc_type = 'XLS'.
  lst_objpack-doc_size = lv_tab_lines * 255.
  APPEND lst_objpack TO li_objpack.

* Target Recipent
  CLEAR lst_reclist.
  lst_reclist-receiver = v_receiver.  "'lwathudura@wiley.com'.
  lst_reclist-rec_type = 'U'.
  lst_reclist-express = lc_x.
  lst_reclist-com_type = lc_addtype.
  lst_reclist-notif_del = lc_x.
  lst_reclist-notif_ndel = lc_x.
  APPEND lst_reclist TO li_reclist.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lv_doc_chng
      put_in_outbox              = lc_x
      sender_address             = v_sender
      sender_address_type        = lc_addtype
      commit_work                = lc_x
    TABLES
      packing_list               = li_objpack
      object_header              = li_objhead
      contents_txt               = li_objtxt
      contents_hex               = li_objbin
      receivers                  = li_reclist
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc EQ 0.
    MESSAGE i590(zqtc_r2).      " email sent succesfully
  ENDIF.

ENDFORM.

FORM f_style_for_numbers .

  v_style1  = v_document->create_simple_element( name = v_xlstyle   parent = v_styles  ).
  v_style1->set_attribute_ns( name = v_id  prefix = v_ss  value = v_xldata1 ).

  v_format  = v_document->create_simple_element( name = v_numberformat   parent = v_style1  ).
  v_format->set_attribute_ns( name = v_xlformat   prefix = v_ss  value = '###0' ).

ENDFORM.

FORM f_check_row_count .

  SELECT COUNT( * )
    INTO @v_extractrows
    FROM zcds_mip_006
    WHERE contract IN @s_sdoc
    AND   media_issue IN @s_issu
    AND   journal IN @s_prod.

  " check the row count for foreground data porcessing
*  SELECT COUNT( * )
*    FROM zcds_mi_r115_rpt INTO @v_extractrows
*    WHERE
*        journal IN @s_prod
*        AND media_issue IN @s_issu
*        AND publication_date IN @s_pbdt
*        AND init_ship_date IN @s_indt
*        AND delivery_date IN @s_dldt
*        AND actual_gi_date IN @s_gddt
*        AND sales_org IN @s_sorg
*        AND dist_channel IN @s_dist
*        AND division IN @s_sdiv
*        AND sales_office IN @s_soff
*        AND contract IN @s_sdoc
*        AND assignment IN @s_assg
*        AND doc_type IN @s_dctp
*        AND item_category IN @s_itcg
*        AND contract_start_date IN @s_csdt
*        AND contract_end_date IN @s_cedt
*        AND release_order IN @s_rele
*        AND bill_block_flag EQ @c_exbb
*        AND del_block_flag EQ @c_exdb
*        AND credit_block_flag EQ @c_excb
*        AND cancel_ord_flag EQ @c_excc
*        AND cancel_res_flag EQ @c_exro
*        AND rel_ord_flag EQ @c_irel
*        AND unearned_flag EQ @c_iamt.
* BOC by Lahiru on 04/12/2021 for OTCM-29592 with ED2K922993 *
  IF rb_fgr = abap_true.
    IF v_extractrows GT v_rowcount.         " Compare foreground record count with preset record count and if exceeded the count terminate the process
      MESSAGE s592(zqtc_r2) WITH text-015 DISPLAY LIKE c_errtype.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSEIF rb_bgr = abap_true..
    IF v_extractrows GT v_rowcount_bg.         " Compare background record count with preset record count and if exceeded the count terminate the process
      MESSAGE s592(zqtc_r2) WITH text-015 DISPLAY LIKE c_errtype.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.
* EOC by Lahiru on 04/12/2021 for OTCM-29592 with ED2K922993 *

ENDFORM.

FORM f_dynamic_screen .

  LOOP AT SCREEN.
    IF screen-group1 EQ 'RB1'.        " Hide report output section
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM f_build_final_output2  USING fp_view TYPE t_contract.
  DATA: ls_alv_output TYPE zstqtc_alvoutput_r115.
  CLEAR ls_alv_output.

  ls_alv_output-journal                = fp_view-journal.
  ls_alv_output-media_issue            = fp_view-media_issue.
  ls_alv_output-contract               = fp_view-contract.
  ls_alv_output-item                   = fp_view-item.
  ls_alv_output-item_category          = fp_view-item_category.
  ls_alv_output-contract_start_date    = fp_view-contract_start_date.
  ls_alv_output-contract_end_date      = fp_view-contract_end_date.
  ls_alv_output-contract_qty           = fp_view-contract_qty.
  ls_alv_output-plant                  = fp_view-plant.
  ls_alv_output-mat_grp_5              = fp_view-mat_grp_5.
  ls_alv_output-mat_grp_3              = fp_view-mat_grp_3.
  ls_alv_output-net_value_item         = fp_view-net_value_item.
  ls_alv_output-currency               = fp_view-currency.
  ls_alv_output-overall_status_desc    = fp_view-overall_status_desc.
  ls_alv_output-credit_status_desc     = fp_view-credit_status_desc.
  ls_alv_output-cancel_reason_desc     = fp_view-cancel_reason_desc.
  ls_alv_output-cancelled_orders_desc  = fp_view-cancelled_orders_desc.
  ls_alv_output-reason_for_cancel_desc = fp_view-reason_for_cancel_desc.
  ls_alv_output-acceptance_date        = fp_view-acceptance_date.
  ls_alv_output-req_cancellation_date  = fp_view-req_cancellation_date.

*  APPEND INITIAL LINE TO i_alv_output ASSIGNING FIELD-SYMBOL(<lfs_alv_output>).

  IF i_issue IS NOT INITIAL.
    READ TABLE i_issue ASSIGNING FIELD-SYMBOL(<lfs_issue>) WITH KEY contract = fp_view-contract
                                                                    item     = fp_view-item
                                                                    journal  = fp_view-journal
                                                                    media_issue = fp_view-media_issue BINARY SEARCH.
    IF <lfs_issue> IS ASSIGNED.
      ls_alv_output-price_grp_desc         = <lfs_issue>-price_grp_desc.
      ls_alv_output-relevant_rar           = <lfs_issue>-rar_relevant.
    ELSE.
      EXIT.
    ENDIF.
  ENDIF.

  IF i_podata IS NOT INITIAL.
    READ TABLE i_podata ASSIGNING FIELD-SYMBOL(<lfs_podata>) WITH KEY contract = fp_view-contract
                                                                      item     = fp_view-item
                                                                      journal  = fp_view-journal
                                                                      media_issue = fp_view-media_issue BINARY SEARCH.
    IF <lfs_podata> IS ASSIGNED.
      ls_alv_output-assignment             = <lfs_podata>-assignment.
      ls_alv_output-contract_reason        = <lfs_podata>-contract_reason.
      ls_alv_output-billing_block_desc     = <lfs_podata>-billing_block_desc.
      ls_alv_output-delivery_block_desc    = <lfs_podata>-delivery_block_desc.
      ls_alv_output-delivery_number        = <lfs_podata>-delivery_number.
      ls_alv_output-delivery_item          = <lfs_podata>-delivery_item.
      ls_alv_output-mat_doc                = <lfs_podata>-mat_doc.
      ls_alv_output-mat_doc_item           = <lfs_podata>-mat_doc_item.
      ls_alv_output-mat_doc_type           = <lfs_podata>-mat_doc_type.
      ls_alv_output-mat_doc_year           = <lfs_podata>-mat_doc_year.
      ls_alv_output-mat_doc_date           = <lfs_podata>-mat_doc_date.
      ls_alv_output-po_number              = <lfs_podata>-po_number.
      ls_alv_output-po_item                = <lfs_podata>-po_item.
      ls_alv_output-po_type                = <lfs_podata>-po_type.
      ls_alv_output-po_del_ind             = <lfs_podata>-po_del_ind.
      ls_alv_output-po_info_rec            = <lfs_podata>-po_info_rec.
      ls_alv_output-po_qty                 = <lfs_podata>-po_qty.
      ls_alv_output-vendor                 = <lfs_podata>-vendor.
      ls_alv_output-vendor_name            = <lfs_podata>-vendor_name.
      ls_alv_output-earned_amount          = <lfs_podata>-earned_amount.
      ls_alv_output-balance                = <lfs_podata>-balance.
      ls_alv_output-release_order_created  = <lfs_podata>-release_order_created.
      ls_alv_output-release_order          = <lfs_podata>-release_order.
      ls_alv_output-release_order_item     = <lfs_podata>-release_order_item.
      ls_alv_output-doc_type               = <lfs_podata>-doc_type.
      ls_alv_output-document_currency      = <lfs_podata>-document_currency.
      ls_alv_output-purchase_requisition   = <lfs_podata>-purchase_requisition.
      ls_alv_output-purchase_requisition_item = <lfs_podata>-purchase_requisition_item.
      ls_alv_output-sales_org              = <lfs_podata>-sales_org.
      ls_alv_output-dist_channel           = <lfs_podata>-dist_channel.
      ls_alv_output-division               = <lfs_podata>-division.
      ls_alv_output-sales_office           = <lfs_podata>-sales_office.
    ELSE.
      EXIT.
    ENDIF.
  ENDIF.

  IF i_count IS NOT INITIAL.
    READ TABLE i_count ASSIGNING FIELD-SYMBOL(<lfs_count>) WITH KEY vbeln = fp_view-contract
                                                                    posnr = fp_view-item BINARY SEARCH.
    IF <lfs_count> IS ASSIGNED.
      ls_alv_output-value_per_issue     = <lfs_count>-value_per_issue.
    ENDIF.
  ENDIF.

  " Read contract document related data
  IF i_contract_data IS NOT INITIAL.
    READ TABLE i_contract_data ASSIGNING FIELD-SYMBOL(<lfs_contract_data>) WITH KEY contract = fp_view-contract
                                                                                    item     = fp_view-item
                                                                                    journal  = fp_view-journal
                                                                                    media_issue = fp_view-media_issue BINARY SEARCH.
    IF sy-subrc = 0.
      ls_alv_output-contract_created     = <lfs_contract_data>-contract_created.
      ls_alv_output-rejection_user       = <lfs_contract_data>-rejection_user.
      ls_alv_output-contract_soldto      = <lfs_contract_data>-contract_soldto.
      ls_alv_output-contract_soldto_name = <lfs_contract_data>-contract_soldto_name.
      ls_alv_output-contract_shipto      = <lfs_contract_data>-contract_shipto.
      ls_alv_output-contract_shipto_name = <lfs_contract_data>-contract_shipto_name.
      ls_alv_output-contract_shipto_ctry = <lfs_contract_data>-contract_shipto_ctry.
      ls_alv_output-invoice_number       = <lfs_contract_data>-invoice_number.
    ENDIF.
  ENDIF.

  " Read claim order data.
  IF i_claim_orders IS NOT INITIAL.
    READ TABLE i_claim_orders ASSIGNING <gfs_claim_orders> WITH KEY contract      = fp_view-contract
                                                                    contract_item = fp_view-item
                                                                    media_issue   = fp_view-media_issue BINARY SEARCH.
    IF sy-subrc = 0.
      ls_alv_output-claims_order = <gfs_claim_orders>-claims_order.
      ls_alv_output-claims_item  = <gfs_claim_orders>-claims_item.
    ENDIF.
  ENDIF.

  " Read Duplicate order count
  IF i_dup_orders IS NOT INITIAL.
    READ TABLE i_dup_orders  ASSIGNING FIELD-SYMBOL(<lfs_dup_orders>) WITH KEY contract      = fp_view-contract
                                                                               contract_item = fp_view-item
                                                                               media_issue   = fp_view-media_issue BINARY SEARCH.
    IF sy-subrc = 0.
      ls_alv_output-duplicate_count = <lfs_dup_orders>-row_count.
    ENDIF.
  ENDIF.
  APPEND ls_alv_output TO i_alv_output.
ENDFORM.
