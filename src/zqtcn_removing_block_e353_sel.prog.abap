*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DELIVERYBLOCK_MANUAL_SEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_MANUAL                             *
* PROGRAM DESCRIPTION: The orders which are Blocked Manually after 3   *
*                     or more dunning letters sent to customers using  *
*                     T-code ZQTC_UNPAID_ORDERS, for these blocked     *
*                     orders, once the customer paid fully system      *
*                     should remove the block automatically without    *
*                     manual intervention                              *
* DEVELOPER      : VDPATABALL                                          *
* CREATION DATE  : 03/10/2022                                          *
* OBJECT ID      : OTCM-57357 / E353                                                    *
* TRANSPORT NUMBER(S):ED2K926054                                       *
*----------------------------------------------------------------------*
TABLES:vbak,vbap,vbkd.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_vkorg FOR vbak-vkorg,  "Sales Orgs
                s_vtweg FOR vbak-vtweg,  "Distribution Channel
                s_spart FOR vbak-spart,  "Division
                s_vbeln FOR vbak-vbeln,  "Sales Order
                s_kunnr FOR vbak-kunnr,  "Sold-to
                s_auart FOR vbak-auart,  "Sales Document Type
                s_pstyv FOR vbap-pstyv,  "Item Category
                s_vkbur FOR vbak-vkbur,  "Sales Office
                s_bsark FOR vbkd-bsark,  "PO type
                s_erdat FOR vbak-erdat,  "Creation Date
                s_lifsk FOR vbak-lifsk DEFAULT '58' OBLIGATORY NO INTERVALS MODIF ID blk. "Delivery Block
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BLK' .
      screen-input = 0.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

AT SELECTION-SCREEN.
  IF s_vbeln IS INITIAL
    AND s_auart IS INITIAL.
    MESSAGE 'Please either Sales order/Sales Doc type is mandtory'(005) TYPE c_e.
  ENDIF.
