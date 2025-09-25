*&---------------------------------------------------------------------*
*&  Include  ZQTCN_AVIOD_DOWNPAYMENT_ITEM
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_RESTRICT_PROFORMA_LINES (Include)
*                      [Copying Requirement Billing Doc Routine - 903]
* PROGRAM DESCRIPTION: Restrict Down payment item in ZF5 During Proforma
* Creation
* DEVELOPER:           Kiran Jagana
* CREATION DATE:       12/13/2018
* OBJECT ID:           E164
* TRANSPORT NUMBER(S): ED2K913977
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*Local variable declarations.

DATA :   lst_vbrp        TYPE vbrpvb,                       "Workarea for vbrp
         lst_vbfa        TYPE vbfavb,                       "Workarea for vbfa
         lst_fpla        TYPE fplavb,                       "Workarea for fpla
         lst_fplt        TYPE fpltvb,                       "Workarea for fplt
         lv_tabix        TYPE sy-tabix,                     "Variable for sy-tabix
         lv_fpltr        TYPE fpltr VALUE '000002', "Item for billing plan/invoice plan/payment cards
         lv_doc_type     TYPE fkart,                "Billing doc type
         lv_sales_office TYPE vkbur,                "Sales office
         lv_po_type      TYPE bsark,                "PO Type
         lv_restrict     TYPE char1.                "restrict bill type

CONSTANTS : lc_doc_type     TYPE rvari_vnam VALUE 'DOC_TYPE',     "Constant for Billing document type
            lc_sales_office TYPE rvari_vnam VALUE 'SALES_OFFICE',    "Constant for sales office
            lc_po_type      TYPE rvari_vnam VALUE 'PO_TYPE',    "Constant for PO type
            lc_devid        TYPE zdevid VALUE 'E174',   "Dev ID
            lc_x            TYPE c VALUE 'X',                      "Flag X
            lc_u            TYPE c VALUE 'U',
            lc_d            TYPE c VALUE 'D',
            lc_con          TYPE char1 VALUE '1',
            lc_con_5        TYPE char1 VALUE '5'.

CLEAR : lst_vbrp,lst_vbfa,lst_fpla,lst_fplt,lv_tabix,
        lv_doc_type,lv_sales_office,lv_po_type.

IF lis_constants IS INITIAL.
* Get Cnonstant values
  SELECT devid,                                                  "Devid
         param1,                                                  "ABAP: Name of Variant Variable
         param2,                                                  "ABAP: Name of Variant Variable
         srno,                                                    "Current selection number
         sign,                                                    "ABAP: ID: I/E (include/exclude values)
         opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                                                     "Lower Value of Selection Condition
         high                                                     "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @lis_constants
   WHERE devid    EQ @lc_devid                                    "Development ID
     AND activate EQ @abap_true.                                  "Only active record
  IF sy-subrc IS INITIAL.
    LOOP AT lis_constants ASSIGNING FIELD-SYMBOL(<lst_const_value1>).
      CASE <lst_const_value1>-param1.
        WHEN lc_sales_office.                                       "Sales Office (SALES_OFFICE)
          CASE <lst_const_value1>-param2.
            WHEN lc_p2_eal.                                       "EAL Only
              APPEND INITIAL LINE TO lrs_sales_offc ASSIGNING FIELD-SYMBOL(<lst_sales_offc1>).
              <lst_sales_offc1>-sign   = <lst_const_value1>-sign.
              <lst_sales_offc1>-option = <lst_const_value1>-opti.
              <lst_sales_offc1>-low    = <lst_const_value1>-low.
              <lst_sales_offc1>-high   = <lst_const_value1>-high.
            WHEN OTHERS.
*           Nothing to do
          ENDCASE.
        WHEN lc_po_type.
          APPEND INITIAL LINE TO lrs_potype ASSIGNING FIELD-SYMBOL(<lst_po_type1>).
          <lst_po_type1>-sign   = <lst_const_value1>-sign.
          <lst_po_type1>-option = <lst_const_value1>-opti.
          <lst_po_type1>-low    = <lst_const_value1>-low.
          <lst_po_type1>-high   = <lst_const_value1>-high.
        WHEN lc_doc_type.
          APPEND INITIAL LINE TO lrs_doctype ASSIGNING FIELD-SYMBOL(<lst_doc_type1>).
          <lst_doc_type1>-sign   = <lst_const_value1>-sign.
          <lst_doc_type1>-option = <lst_const_value1>-opti.
          <lst_doc_type1>-low    = <lst_const_value1>-low.
          <lst_doc_type1>-high   = <lst_const_value1>-high.
        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF.

*--*Check the conditions doc type, sales office and PO type
IF vbrk-fkart IN lrs_doctype AND vbak-vkbur IN lrs_sales_offc AND vbak-bsark IN lrs_potype.
*Restrict the ZF5 item,while creating Proforma invoice and avoiding the
*Downpayment item.
  CLEAR lv_restrict.
  LOOP AT xfplt ASSIGNING FIELD-SYMBOL(<lst_xfplt_area>) WHERE fplnr = fplt-fplnr
                                                         AND   fareg = lc_con
                                                         AND   updkz NE lc_d.
    lv_restrict = abap_true.
    <lst_xfplt_area>-updkz = lc_d.

  ENDLOOP.
  IF lv_restrict = abap_true.
    sy-subrc = 0.
  ELSE.
    sy-subrc = 4.

  ENDIF."lv_restrict = abap_true.
*
ENDIF.
