*&---------------------------------------------------------------------*
*&  Include           ZQTCN_IC_INVOICE_ORD_FIELDS
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IC_INVOICE_ORD_FIELDS (Called from - ZXF06U06
*                            (User-exit - Called from EXIT_SAPLIEDI_101)
* PROGRAM DESCRIPTION: IC Invoice Doc - Populate Sales order Fields
* REFERENCE NO: CR-769
* DEVELOPER:    HIPATEL (Himanshu Patel)
* DATE:         03/16/2018
* TRANSPORT NUMBER(S):  ED2K911408
* DESCRIPTION:  Processing of transfer structures SD-FI-CR769 - when a
*               subscription order results in Inter- company AP posting
*               with BKPF-AWTYP=IBKPF, then passing contract number and
*               item number to BSEG-VBEL2 and BSEG-POSN2 respectively.
*               (Change the standard SD copy control for credit memo
*               requests to populate the main SD document number (parent)
*               into the FI accounting document sales document/item fields
*               instead of the Credit Memo Request document number. AP I/C
*               generated from SD I/C billing should populate the sales
*               document/item number).
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:    ED1K907191
* REFERENCE NO:   INC0197445
* DEVELOPER:      HIPATEL (Himanshu Patel)
* DATE:           06/06/2018
* DESCRIPTION:    Material from Segment E1EDP19-IDTNR is moved to Acct.
*                 Doc Line Item (BSEG-MATNR) to populate MPM Issue.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:    ED1K907660
* REFERENCE NO:   INC0198183
* DEVELOPER:      HIPATEL (Himanshu Patel)
* DATE:           06/11/2018
* DESCRIPTION:    Getting original Subscription Order/Line Item  for
*                 Credit Memo Request and moved to Acct. Doc Line Item
*                 (BSEG-VBEL2 and BSEG-POSN2) to populate Sales Document
*                 and Item
*----------------------------------------------------------------------*
*Data declaration
DATA:
  lst_e1edk14 TYPE e1edk14,                                "IDoc: Document Header Organizational Data
  lst_e1edp02 TYPE e1edp02,                                "IDoc: Document Item Reference Data
  lst_e1edka1 TYPE e1edka1,                                "Document Header Partner Information
  lst_data    TYPE ftpost1,                                "Document Header and Items for Internal Posting Interface
  lst_e1edp19 TYPE e1edp19,                                "IDoc: Document Item Object Identification +<HIPATEL> <INC0197445>
  lv_index    TYPE i,                                      "Table record
  lv_partner  TYPE lifnr_ed1,                              "Vendor number at customer location
  lv_bukrs    TYPE edi_orgid,                              "IDOC organization
  lv_cblartkr TYPE cblartkr,                               "EDI: Invoice Document Type
*BOC <HIPATEL> <INC0198183> <ED1K907660> <06/11/2019>
  lv_vbelv    TYPE vbeln_von,                              "Sales and distribution document number
  lv_posnv    TYPE posnr_von.                              "Item number of the SD document
*EOC <HIPATEL> <INC0198183> <ED1K907660> <06/11/2019>

*Constant declaration
CONSTANTS: lc_vbel2   TYPE bdc_fnam   VALUE 'COBL-KDAUF',        "Sales Order Number
           lc_posn2   TYPE bdc_fnam   VALUE 'COBL-KDPOS',        "Sales Order Item number
           lc_stype   TYPE stype_pi   VALUE 'P',                 "Record Type for Internal Posting Interface
           lc_e1edka1 TYPE edilsegtyp VALUE 'E1EDKA1',           "Document Header Partner Information
           lc_e1edk14 TYPE edilsegtyp VALUE 'E1EDK14',           "Document Header Organizational Data
           lc_re      TYPE edi3035_a  VALUE 'RE',                "Invoice recipient
           lc_011     TYPE edi_qualfo VALUE '011',               "Company code
           lc_li      TYPE edippartyp VALUE 'LI',                "Partner Type
           lc_k       TYPE stype_pi   VALUE 'K',                 "Record Type for Internal Posting Interface
           lc_blart   TYPE bdc_fnam   VALUE 'BKPF-BLART',        "Document type
           lc_matnr   TYPE bdc_fnam   VALUE 'COBL-MATNR',        "Material Number +<HIPATEL> <INC0197445>
*BOC <HIPATEL> <INC0198183> <ED1K907660> <06/11/2019>
           lc_vbtyp_k TYPE vbtyp      VALUE 'K',                 " Credit Memo Request
           lc_vbtyp_g TYPE vbtyp      VALUE 'G',                 " Contract
           lc_vbtyp_c TYPE vbtyp      VALUE 'C'.                 " Order
*EOC <HIPATEL> <INC0198183> <ED1K907660> <06/11/2019>


*Read Idoc data
READ TABLE idoc_data ASSIGNING <lst_idoc_data>
     INDEX idoc_data_index.
IF sy-subrc EQ 0.
  CASE <lst_idoc_data>-segnam.
    WHEN 'E1EDP02'.                                             "IDoc: Document Item Reference Data
      lst_e1edp02 = <lst_idoc_data>-sdata.
      CASE lst_e1edp02-qualf.
        WHEN '002'.
          CLEAR: lv_partner, lv_bukrs.
          LOOP AT idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_rec>) WHERE segnam EQ lc_e1edka1 OR
                                                                         segnam EQ lc_e1edk14.
            CASE <lst_idoc_rec>-segnam.
              WHEN lc_e1edka1.
                lst_e1edka1 = <lst_idoc_rec>-sdata.
                IF lst_e1edka1-parvw = lc_re.      "Invoice recipient
                  lv_partner = lst_e1edka1-lifnr.  "Vendor number at customer location
                ELSE.
                  CONTINUE.
                ENDIF.
              WHEN lc_e1edk14.
                lst_e1edk14 = <lst_idoc_rec>-sdata.
                IF lst_e1edk14-qualf = lc_011.   "Company code
                  lv_bukrs = lst_e1edk14-orgid.  "IDOC organization
                ELSE.
                  CONTINUE.
                ENDIF.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.
*Read document type to
          CLEAR lv_cblartkr.
          SELECT SINGLE cblartkr            "EDI: Invoice Document Type
            INTO lv_cblartkr
            FROM t076s                      "EDI-INVOIC: Program Parameters
            WHERE parart EQ lc_li AND       "Partner Type
                  konto  EQ lv_partner AND  "Partner number
                  ktbukrs EQ lv_bukrs.      "Company Code
          IF NOT lv_cblartkr IS INITIAL.
            READ TABLE document_data INTO DATA(lst_doc_data) WITH KEY stype = lc_k
                                                                      fnam  = lc_blart.
            IF sy-subrc = 0 AND lst_doc_data-fval EQ lv_cblartkr.
*Transfer Sales order number and Line item Item
              IF NOT lst_e1edp02-belnr IS INITIAL AND NOT lst_e1edp02-zeile IS INITIAL.
                DESCRIBE TABLE document_data LINES lv_index.
                READ TABLE document_data INTO DATA(lst_last_rec) INDEX lv_index.
                IF sy-subrc = 0.
*BOC <HIPATEL> <INC0198183> <ED1K907660> <06/11/2019>
* Fetch the original Sales Document number and item number against
* which the CMR is created - in case of CMR scenario
                  CLEAR: lv_vbelv, lv_posnv.
                  SELECT SINGLE vbelv posnv
                    INTO (lv_vbelv, lv_posnv)
                    FROM vbfa
                    WHERE vbeln = lst_e1edp02-belnr
                    AND   posnn = lst_e1edp02-zeile
                    AND   vbtyp_n = lc_vbtyp_k      " Credit Memo Request
                    AND   vbtyp_v IN (lc_vbtyp_g,   " Contract
                                      lc_vbtyp_c).  " Order
                  IF sy-subrc = 0.
* Passing the contract number and item number to BSEG-VBEL2 and BSEG-POSN2 respectively
                    lst_e1edp02-belnr = lv_vbelv.  " Original Sales Order Number against which CMR is created
                    lst_e1edp02-zeile = lv_posnv.  " Sales Document Item
                  ENDIF.
*EOC <HIPATEL> <INC0198183> <ED1K907660> <06/11/2019>
                  lst_data-stype = lc_stype.
                  lst_data-count = lst_last_rec-count.
                  lst_data-fnam  = lc_vbel2.
                  lst_data-fval  = lst_e1edp02-belnr.
                  APPEND lst_data TO document_data.
                  CLEAR lst_data.

                  lst_data-stype = lc_stype.
                  lst_data-count = lst_last_rec-count.
                  lst_data-fnam  = lc_posn2.
                  lst_data-fval  = lst_e1edp02-zeile.
                  APPEND lst_data TO document_data.
                  CLEAR lst_data.
                ENDIF.  "IF sy-subrc = 0.
              ENDIF.  "IF NOT lst_e1edp02-belnr IS INITIAL AND NOT lst_e1edp02-zeile IS INITIAL.
            ENDIF.  "IF sy-subrc = 0 AND lst_doc_data-fval EQ lv_cblartkr.
          ENDIF.  "IF NOT lv_cblartkr IS INITIAL.
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
*BOC <HIPATEL> <INC0197445> <ED1K907191> <06/06/2018>
    WHEN 'E1EDP19'.           "IDoc: Document Item Object Identification
*Get IDTNR(Material Number) from segment
      lst_e1edp19 = <lst_idoc_data>-sdata.
*To Get Count number read last record of the table
      DESCRIBE TABLE document_data LINES lv_index.
      CLEAR lst_last_rec.
      READ TABLE document_data INTO lst_last_rec INDEX lv_index.
      IF sy-subrc = 0.
        lst_data-stype = lc_stype.
        lst_data-count = lst_last_rec-count.
        lst_data-fnam  = lc_matnr.
        lst_data-fval  = lst_e1edp19-idtnr.
        APPEND lst_data TO document_data.
        CLEAR lst_data.
      ENDIF.
*EOC <HIPATEL> <INC0197445> <ED1K907191> <06/06/2018>
    WHEN OTHERS.
*     Nothing to do
  ENDCASE.

ENDIF.
