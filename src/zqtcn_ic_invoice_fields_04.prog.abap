*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IC_INVOICE_FIELDS_04 (Called from ZXF06U07)
* PROGRAM DESCRIPTION: IC Invoice Doc - Populate additional Fields
*                      Populate Tax related details
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/29/2017
* OBJECT ID: E163
* TRANSPORT NUMBER(S):  ED2K906862
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lst_e1edk02_e163 TYPE e1edk02,                                "IDoc: Document header reference data
  lst_e1edk14_e163 TYPE e1edk14.                                "IDoc: Document Header Organizational Data
*  lst_e1edp02_e163 TYPE e1edp02.

DATA:
  lv_company_code TYPE bukrs,                                   "Company Code
  lv_ic_bill_doc  TYPE belnr_d.                                 "IC Billing Document Number

DATA:
  li_tax_data     TYPE feb_t_fttax.                             "Taxes for Internal Posting Interface

READ TABLE idoc_contrl ASSIGNING FIELD-SYMBOL(<lst_idoc_contrl>)
     INDEX idoc_contrl_index.
IF sy-subrc EQ 0.
  LOOP AT idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>)
    WHERE docnum EQ <lst_idoc_contrl>-docnum.
    CASE <lst_idoc_data>-segnam.
      WHEN 'E1EDK02'.                                           "IDoc: Document header reference data
        lst_e1edk02_e163 = <lst_idoc_data>-sdata.
        CASE lst_e1edk02_e163-qualf.
          WHEN '009'.
            lv_ic_bill_doc = lst_e1edk02_e163-belnr.            "IC Billing Document Number
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN 'E1EDK14'.                                           "IDoc: Document Header Organizational Data
        lst_e1edk14_e163 = <lst_idoc_data>-sdata.
        CASE lst_e1edk14_e163-qualf.
          WHEN '003'.
            lv_company_code = lst_e1edk14_e163-orgid.           "Company Code
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.

  IF tax_data[] IS NOT INITIAL.
    SORT tax_data BY bschl.
    DELETE ADJACENT DUPLICATES FROM tax_data
           COMPARING bschl.
*   Fetch Accounting Document Segment Details
    SELECT bukrs,                                               "Company Code
           belnr,                                               "Accounting Document Number
           gjahr,                                               "Fiscal Year
           buzei,                                               "Number of Line Item Within Accounting Document
           bschl,                                               "Posting Key
           wrbtr                                                "Amount in Document Currency
      FROM bseg
      INTO TABLE @DATA(li_bseg_e163)
       FOR ALL ENTRIES IN @tax_data
     WHERE bukrs EQ @lv_company_code
       AND belnr EQ @lv_ic_bill_doc
       AND bschl EQ @tax_data-bschl
       AND buzid EQ @c_id_line_tx.
    IF sy-subrc EQ 0.
      SORT li_bseg_e163 BY bschl.
      LOOP AT tax_data ASSIGNING FIELD-SYMBOL(<lst_tax_data>).
        READ TABLE li_bseg_e163 TRANSPORTING NO FIELDS
             WITH KEY bschl = <lst_tax_data>-bschl
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          LOOP AT li_bseg_e163 ASSIGNING FIELD-SYMBOL(<lst_bseg_e163>) FROM sy-tabix.
            IF <lst_bseg_e163>-bschl NE <lst_tax_data>-bschl.
              EXIT.
            ENDIF.
            APPEND INITIAL LINE TO li_tax_data ASSIGNING FIELD-SYMBOL(<lst_tax_data_n>).
            MOVE-CORRESPONDING <lst_tax_data> TO <lst_tax_data_n>.
            <lst_tax_data_n>-fwste = <lst_bseg_e163>-wrbtr.
          ENDLOOP.
        ENDIF.
      ENDLOOP.

      tax_data[] = li_tax_data[].                               "Taxes for Internal Posting Interface
    ENDIF.
  ENDIF.
ENDIF.
