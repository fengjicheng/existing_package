*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MED_ISS_OPT_R115_SEL_NEW
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data.

  REFRESH: i_view[].
  CLEAR: v_count.

*  IF s_vdat[] IS NOT INITIAL AND s_cdat[] IS INITIAL.
*    s_cdat-sign = 'I'.
*    s_cdat-option = 'BT'.
*    s_cdat-low = '19000101'.
*    s_cdat-high = '99991231'.
*    APPEND s_cdat TO s_cdat.
*  ELSEIF s_vdat[] IS INITIAL AND s_cdat[] IS NOT INITIAL.
*    s_vdat-sign = 'I'.
*    s_vdat-option = 'BT'.
*    s_vdat-low = '19000101'.
*    s_vdat-high = '99991231'.
*    APPEND s_vdat TO s_vdat.
*  ENDIF.

  SELECT * FROM zcds_mi_r115_rpt INTO TABLE @i_view
  WHERE
    journal IN @s_prod
    AND media_issue IN @s_issu
    AND publication_date IN @s_pbdt
    AND init_ship_date IN @s_indt
    AND delivery_date IN @s_dldt
    AND actual_gi_date IN @s_gddt
    AND sales_org IN @s_sorg
    AND dist_channel IN @s_dist
    AND division IN @s_sdiv
    AND sales_office IN @s_soff
    AND contract IN @s_sdoc
    AND assignment IN @s_assg
    AND doc_type IN @s_dctp
    AND item_category IN @s_itcg
    AND contract_start_date IN @s_csdt
    AND contract_end_date IN @s_cedt
    AND release_order IN @s_rele
    AND bill_block_flag IN @s_exbb
    AND del_block_flag IN @s_exdb
    AND credit_block_flag IN @s_excb
    AND cancel_ord_flag IN @s_excc
    AND cancel_res_flag IN @s_exro
    AND rel_ord_flag IN @s_irel
    AND unearned_flag IN @s_iamt
    .
**
**    AND ( ( ( contract_start_date GE @s_vdat-low AND contract_end_date LE @s_vdat-high )
**              OR  ( contract_end_date GE @s_vdat-low AND contract_start_date LE @s_vdat-high ) ) ).
**  "AND ( contract_start_date GE @s_cdat-low AND contract_end_date LE @s_cdat-high ).


  IF sy-subrc = 0.
    SORT i_view.
    DELETE ADJACENT DUPLICATES FROM i_view COMPARING ALL FIELDS.

**Additonal filters based on check boxes

*if s_iamt[] is NOT INITIAL.
*    IF s_iamt-low = 'YES'. "Exclude docs with billing block
*      SORT i_view by earned_amount.
*      DELETE i_view WHERE earned_amount <> 0.
*     ELSEIF s_iamt-low = 'NO'.
*       SORT i_view by earned_amount.
*      DELETE i_view WHERE earned_amount = 0.
*    ENDIF.
*ENDIF.


    IF i_view IS NOT INITIAL.

      LOOP AT i_view ASSIGNING <fs_view>.
        IF <fs_view>-contract IS NOT INITIAL AND <fs_view>-item IS NOT INITIAL.
          <fs_view>-value_per_issue = <fs_view>-net_value / <fs_view>-issue_count.
        ENDIF.
      ENDLOOP.

      DESCRIBE TABLE i_view LINES v_count.
      SHIFT v_count LEFT DELETING LEADING '0'.
      MESSAGE s001(zren) WITH v_count.
    ELSE.
      MESSAGE i000(zren) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.

  ELSE.
    MESSAGE i000(zren) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_build_fieldcatalog
*&---------------------------------------------------------------------*

FORM f_build_fieldcatalog .

  CLEAR:w_fieldcat,i_fieldcat[].

  PERFORM f_build_fcatalog USING:
'JOURNAL'                       'I_VIEW' text-f01 '' '18' '18', "Media Product
'MEDIA_ISSUE'                   'I_VIEW' text-f02 '' '18' '18', "Media Issue
'PUBLICATION_DATE'              'I_VIEW' text-f03 '' '' '', "Publishing Date
'INIT_SHIP_DATE'                'I_VIEW' text-f72 '' '' '', "Initial Shipping Date
'DELIVERY_DATE'                 'I_VIEW' text-f73 '' '' '', "Delivery Date
'ACTUAL_GI_DATE'                'I_VIEW' text-f04 '' '' '', "Actual Goods Arrival Date
'MATERIAL_STATUS'               'I_VIEW' text-f05 '' '50' '50', "Cross Media Issue Plant Status
'DISTR_CHAIN_STATUS'            'I_VIEW' text-f06 '' '50' '50', "Cross Medua Issue Dist. Chain Status
'MI_IC_GROUP,'                  'I_VIEW' text-f07 '' '50' '50', "Media Issue Item Category Group
'DIST_CHAIN_STATUS,'            'I_VIEW' text-f08 '' '50' '50', "Dist. Chain Specific Status
'ISSUE_NUMBER'                  'I_VIEW' text-f09 '' '4' '4', "Issue Number
'VOL_COPY_NO'                   'I_VIEW' text-f10 '' '9' '9', "Volume/Copy Number
'YEAR_NUMBER'                   'I_VIEW' text-f11 '' '4' '4', "Year
'PUBLICATION_TYPE'              'I_VIEW' text-f12 '' '2' '2', "Publication Type
'DEL_PLANT'                     'I_VIEW' text-f13 '' '4' '4', "Delivering Plant
'PROFIT_CENTER'                 'I_VIEW' text-f14 '' '10' '10', "Profit Center
'PLAN_STATUS_DESC'              'I_VIEW' text-f15 '' '30' '30', "Shipping Schedule Status
*'PLAN_STATUS_DESC'              'I_VIEW' text-f16 '', "Shipping Schedule Status Desc (Check if this can be used for both)
'PLANNED_RO_FROM'               'I_VIEW' text-f17 '' '' '', "Planned Release Order Creation Date From
'PLANNED_RO_TO'                 'I_VIEW' text-f18 '' '' '', "Planned Release Order Creation Date To
'CONTRACT'                      'I_VIEW' text-f19 'X' '10' '10', "Contract Number
'ITEM'                          'I_VIEW' text-f20 '' '6' '6', "Contract Item
'ASSIGNMENT'                    'I_VIEW' text-f74 '' '30' '30', "Assignment
'DOC_TYPE'                      'I_VIEW' text-f21 '' '4' '4', "Doc Type
'CONTRACT_REASON'               'I_VIEW' text-f22 '' '100' '100', "Contract Reason
'CONTRACT_START_DATE'           'I_VIEW' text-f23 '' '' '', "Contract Start Date
'CONTRACT_END_DATE'             'I_VIEW' text-f24 '' '' '', "Contract End Date
'CONTRACT_QTY'                  'I_VIEW' text-f25 '' '' '', "Contract Qty
'PLANT'                         'I_VIEW' text-f26 '' '4' '4', "Contract Plant
'MAT_GRP_5'                     'I_VIEW' text-f27 '' '100' '100', "Material Grp 5
'MAT_GRP_3'                     'I_VIEW' text-f28 '' '100' '100', "Material Grp 3
'ITEM_CATEGORY'                 'I_VIEW' text-f29 '' '4' '4', "Item Category
'NET_VALUE_ITEM'                'I_VIEW' text-f30 '' '' '', "Net Value (Item)
'CURRENCY'                      'I_VIEW' text-f31 '' '5' '5', "Currency
'BILLING_BLOCK_DESC'            'I_VIEW' text-f32 '' '50' '50', "Billing Block
'DELIVERY_BLOCK_DESC'           'I_VIEW' text-f33 '' '50' '50', "Delivery Block
'OVERALL_STATUS_DESC'           'I_VIEW' text-f34 '' '50' '50', "Overall Contract Status
'CREDIT_STATUS_DESC'            'I_VIEW' text-f35 '' '50' '50', "Credit Status
'CANCEL_REASON_DESC'            'I_VIEW' text-f36 '' '100' '100', "Rejection Reason
'CANCELLED_ORDERS_DESC'         'I_VIEW' text-f37 '' '100' '100', "Contract Cancellation
'REASON_FOR_CANCEL_DESC'        'I_VIEW' text-f38 '' '100' '100', "Cancellation Reason
'ACCEPTANCE_DATE'               'I_VIEW' text-f39 '' '' '', "Acceptance Date
'REQ_CANCELLATION_DATE'         'I_VIEW' text-f40 '' '' '', "Requested Cancellation Date
'PRICE_GRP_DESC'                'I_VIEW' text-f41 '' '50' '50', "Price Group
'DELIVERY_NUMBER'               'I_VIEW' text-f42 '' '10' '10', "Delivery Number
'DELIVERY_ITEM'                 'I_VIEW' text-f43 '' '6' '6', "Delivery Item
'MAT_DOC'                       'I_VIEW' text-f44 '' '10' '10', "Material Doc
'MAT_DOC_ITEM'                  'I_VIEW' text-f45 '' '6' '6', "Material Doc Item
'MAT_DOC_TYPE'                  'I_VIEW' text-f46 '' '3' '3', "Material Doc Type
'MAT_DOC_YEAR'                  'I_VIEW' text-f47 '' '4' '4', "Material Doc Year
'MAT_DOC_DATE'                  'I_VIEW' text-f48 '' '' '', "Material Doc Posting Date
'PO_NUMBER'                     'I_VIEW' text-f49 '' '10' '10', "Purchase Orer
'PO_ITEM'                       'I_VIEW' text-f50 '' '6' '6' , "PO Item
'PO_TYPE'                       'I_VIEW' text-f51 '' '4' '4', "PO Type
'PO_DEL_IND'                    'I_VIEW' text-f52 '' '1' '1', "PO Deletion Indicator
'PO_INFO_REC'                   'I_VIEW' text-f53 '' '10' '10', "Purchasing Info Record
'PO_QTY'                        'I_VIEW' text-f54 '' '' '', "PO Qty
*'ISSUE_COUNT'                   'I_VIEW' text-f57 ''
*'NET_VALUE'                     'I_VIEW' text-f58 '',
'VALUE_PER_ISSUE'               'I_VIEW' text-f55 '' '' '', "Single Issue Value
'EARNED_AMOUNT'                 'I_VIEW' text-f56 '' '' '', "Earned Amount
*'BILLED_AMOUNT'                 'I_VIEW' text-f57 '', "Billed Amount
'BALANCE'                       'I_VIEW' text-f58 '' '' '', "Balance Amount
'DOCUMENT_CURRENCY'             'I_VIEW' text-f59 '' '5' '5', "Document Currency
'RELEASE_ORDER_CREATED'         'I_VIEW' text-f60 '' '1' '1', "Release Order Created
'RELEASE_ORDER'                 'I_VIEW' text-f61 '' '10' '10', "Release Order
'RELEASE_ORDER_ITEM'            'I_VIEW' text-f62 '' '6' '6', "Release order item
'PURCHASE_REQUISITION'          'I_VIEW' text-f63 '' '10' '10', "Purchase Requisition
'PURCHASE_REQUISITION_ITEM'     'I_VIEW' text-f64 '' '6' '6', "PR Item
'VENDOR'                        'I_VIEW' text-f70 '' '250' '250', "Vendor
'VENDOR_NAME'                   'I_VIEW' text-f71 '' '35' '35', "Vendor Name
'RELEVANT_RAR'                  'I_VIEW' text-f65 '' '10' '10', "Relevant for RAR
'SALES_ORG'                     'I_VIEW' text-f66 '' '4' '4', "Sales Org
'DIST_CHANNEL'                  'I_VIEW' text-f67 '' '2' '2', "Dist. Channel
'DIVISION'                      'I_VIEW' text-f68 '' '2' '2', "Division
'SALES_OFFICE'                  'I_VIEW' text-f69 '' '4' '4' "Sales Office
.


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
    TABLES
      t_outtab                 = i_view
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

ENDFORM.                  " f_list_display

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

      ENDCASE.
  ENDCASE.

ENDFORM.                      " f_handle_user_command

***&---------------------------------------------------------------------*
***&      Form  f_handle_user_command
***&---------------------------------------------------------------------*
FORM f_set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZPF_STATUS_R115_OLD'.
ENDFORM. "Set_pf_status
