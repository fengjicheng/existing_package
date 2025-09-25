*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DELETE_ADDITIONAL_ITEM
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DELETE_ADDITIONAL_ITEM (Include)
*               Called from "userexit_save_document_prepare(RV60AFZZ)"
* PROGRAM DESCRIPTION: This userexit used to remove unwanted line item
*                      from Proforma when multiple billing plans persists
* DEVELOPER      : Prabhu
* CREATION DATE  : 08/03/2018
* OBJECT ID      : E174 / CR6082
* TRANSPORT NUMBER(S): ED2K912901
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*--*Structure to hold constant table
DATA :   lst_vbrp        TYPE vbrpvb,                       "Workarea for vbrp
         lst_vbfa        TYPE vbfavb,                       "Workarea for vbfa
         lst_fpla        TYPE fplavb,                       "Workarea for fpla
         lst_fplt        TYPE fpltvb,                       "Workarea for fplt
         lv_tabix        TYPE sy-tabix,                     "Variable for sy-tabix
         lv_fpltr        TYPE fpltr VALUE '000002', "Item for billing plan/invoice plan/payment cards
         lv_doc_type     TYPE fkart,                "Billing doc type
         lv_sales_office TYPE vkbur,                "Sales office
         lv_po_type      TYPE bsark.                "PO Type
CONSTANTS : lc_doc_type     TYPE rvari_vnam VALUE 'DOC_TYPE',     "Constant for Billing document type
            lc_sales_office TYPE rvari_vnam VALUE 'SALES_OFFICE',    "Constant for sales office
            lc_po_type      TYPE rvari_vnam VALUE 'PO_TYPE',    "Constant for PO type
            lc_devid        TYPE zdevid VALUE 'E174',   "Dev ID
            lc_p2_eal       TYPE rvari_vnam VALUE 'EAL',
            lc_x            TYPE c VALUE 'X',                      "Flag X
            lc_u            TYPE c VALUE 'U'.

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
    LOOP AT lis_constants ASSIGNING FIELD-SYMBOL(<lst_const_value>).
      CASE <lst_const_value>-param1.
        WHEN lc_sales_office.                                       "Sales Office (SALES_OFFICE)
          CASE <lst_const_value>-param2.
            WHEN lc_p2_eal.                                       "EAL Only
              APPEND INITIAL LINE TO lrs_sales_offc ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
              <lst_sales_offc>-sign   = <lst_const_value>-sign.
              <lst_sales_offc>-option = <lst_const_value>-opti.
              <lst_sales_offc>-low    = <lst_const_value>-low.
              <lst_sales_offc>-high   = <lst_const_value>-high.
            WHEN OTHERS.
*           Nothing to do
          ENDCASE.
        WHEN lc_po_type.
          APPEND INITIAL LINE TO lrs_potype ASSIGNING FIELD-SYMBOL(<lst_po_type>).
          <lst_po_type>-sign   = <lst_const_value>-sign.
          <lst_po_type>-option = <lst_const_value>-opti.
          <lst_po_type>-low    = <lst_const_value>-low.
          <lst_po_type>-high   = <lst_const_value>-high.
        WHEN lc_doc_type.
          APPEND INITIAL LINE TO lrs_doctype ASSIGNING FIELD-SYMBOL(<lst_doc_type>).
          <lst_doc_type>-sign   = <lst_const_value>-sign.
          <lst_doc_type>-option = <lst_const_value>-opti.
          <lst_doc_type>-low    = <lst_const_value>-low.
          <lst_doc_type>-high   = <lst_const_value>-high.
        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF.


*--*Check the conditions doc type, sales office and PO type
IF vbrk-fkart IN lrs_doctype AND vbak-vkbur IN lrs_sales_offc AND vbak-bsark IN lrs_potype.
  IF xvbfa[] IS NOT INITIAL.
    LOOP AT xvbrp INTO lst_vbrp." WHERE aubel eq VBAK-VBELN.
      lv_tabix = sy-tabix.
*--*Check the preceeding document Item
      CLEAR : lst_vbfa.
      READ TABLE xvbfa INTO lst_vbfa WITH KEY vbelv = lst_vbrp-vgbel "Sale document
                                              posnv = lst_vbrp-posnr."Billing doc Item
      IF sy-subrc NE 0. "Doesn't exist means new item number in billing doc
*--*Check billing plans for multiples
        READ TABLE xvbfa INTO lst_vbfa WITH KEY vbelv = lst_vbrp-vgbel "Sales Document
                                                posnv = lst_vbrp-vgpos "Sales Document Item
                                                fpltr = lv_fpltr.      "Second Billing plan
        IF sy-subrc EQ 0.
          DELETE xvbrp INDEX lv_tabix.
*--*Delete extra Item in Document flow
          READ TABLE xvbfa INTO lst_vbfa WITH KEY vbelv = lst_vbrp-vgbel
                                                  posnn = lst_vbrp-posnr
                                                  vbtyp_n = lc_u.
          IF sy-subrc EQ 0.
            DELETE xvbfa INDEX sy-tabix.
          ENDIF.
        ENDIF.
      ENDIF.
*        ENDIF.
    ENDLOOP.
  ENDIF.
ENDIF.
