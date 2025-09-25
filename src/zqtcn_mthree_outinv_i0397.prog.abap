*&---------------------------------------------------------------------*
*&  Include  ZQTCN_MTHREE_OUTINV_I0397_1
*&---------------------------------------------------------------------*
* Include     : ZXEDFU02
* Prog name   : ZQTCN_MTHREE_OUTINV_I0397_1
* REVISION NO : ED2K923561                                             *
* REFERENCE NO: OTCM-44643                                             *
* DEVELOPER   : Murali (mimmadiset)                            *
* DATE        : 05/26/2021                                             *
* OBJECT ID   : I0397                                                  *
* DESCRIPTION : * DESCRIPTION : As and when a billing document is generated and saved in
*SAP for this Hungarian client,it will create an IDOC and sent out to the middleware.
*The middleware than converts it into a compliant XML format and transfers
*the invoice Data to the Hungarian NAV system.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  FMM-7286
* REFERENCE NO: ED2K925554
* DEVELOPER:    Murali
* DATE:         01/13/2022
* DESCRIPTION:  Change the logic of payment term
*----------------------------------------------------------------------*
TYPES:BEGIN OF lty1_fkart,
        sign   TYPE tvarv_sign,                                  " Sign
        option TYPE tvarv_opti,                                  " Option
        low    TYPE fkart,                                       " Doc type
        high   TYPE fkart,                                       " Doc type
      END OF lty1_fkart,
      ltt1_fkart TYPE STANDARD TABLE OF lty1_fkart INITIAL SIZE 0.
DATA:lst1_fkart      TYPE lty1_fkart.
***Local constant variable declaration
CONSTANTS:lc1_e1edk01      TYPE edilsegtyp VALUE 'E1EDK01',      " Segment E1EDK01
          lc1_z1qtc_header TYPE edilsegtyp VALUE 'Z1QTC_HEADER', "Segment Z1QTC_HEADER
          lc1_e1edk03      TYPE edilsegtyp VALUE 'E1EDK03',      " Segment E1EDK01
          lc1_e1edk05      TYPE edilsegtyp VALUE 'E1EDK05',      " Segment E1EDK01
          lc1_e1edk04      TYPE edilsegtyp VALUE 'E1EDK04',      " Segment E1EDK04
          lc1_e1edka1      TYPE edilsegtyp VALUE 'E1EDKA1',      " Segment E1EDKA1
          lc1_e1edk14      TYPE edilsegtyp VALUE 'E1EDK14',      " Segment e1edk14
          lc1_e1edk02      TYPE edilsegtyp VALUE 'E1EDK02',      " Segment E1EDK02
          lc1_e1edp01      TYPE edilsegtyp VALUE 'E1EDP01',      " Segment E1EDK02
          lc1_e1edp26      TYPE edilsegtyp VALUE 'E1EDP26',      " Segment E1EDP26
          lc1_e1edp04      TYPE edilsegtyp VALUE 'E1EDP04',      " Segment E1EDP26
          lc1_z1qtc_item   TYPE edilsegtyp VALUE 'Z1QTC_ITEM',   " Segment Z1QTC_ITEM
          lc1_e1edp19      TYPE edilsegtyp VALUE 'E1EDP19',      " Segment E1EDP19
          lc1_qualf_009    TYPE edi_qualfr VALUE '009',          " Qualf_009
          lc1_qualf_001    TYPE edi_qualfr VALUE '001',          " Qualf_001
          lc1_qualf_002    TYPE edi_qualfr VALUE '002',          " Qualf_002
          lc1_qualf_003    TYPE edi_qualfr VALUE '003',          " Qualf_003
          lc1_qualf_087    TYPE edi_qualfr VALUE '087',          " Qualf_087
          lc1_qualf_008    TYPE edi_qualfr VALUE '008',          " Qualf_008
          lc1_qualf_011    TYPE edi_qualfr VALUE '011',          " Qualf_008
          lc1_qualf_026    TYPE edi_qualfr VALUE '026',          " Qualf_008
          lc_gjahr         TYPE gjahr      VALUE '0000',         " Fiscal Year
          lc_i0397         TYPE zdevid     VALUE 'I0397',        " Object id
          lc_doc_type      TYPE /idt/document_type VALUE 'VBRK',
          lc_fkart         TYPE rvari_vnam VALUE 'FKART',
          lc_fkart_m       TYPE rvari_vnam VALUE 'FKART_M',
          lc_fkart_zcr     TYPE fkart      VALUE 'ZCR',
          lc_fkart_zs1     TYPE fkart      VALUE 'ZS1',
          lc_vbtyp_m       TYPE vbtyp_v    VALUE 'M',   "Invoice
          lc_g             TYPE vbtyp_n    VALUE 'G',   "Contract
          lc1_vbtyp_o      TYPE vbtyp_v    VALUE 'O',   "Credit memo
          lc_fkart_xb      TYPE rvari_vnam VALUE 'FKART_XB',
          lc_col           TYPE char1      VALUE '-',
          lc_hu0           TYPE bptaxtype  VALUE 'HU0',
          lc_zcr           TYPE fkart      VALUE 'ZCR', "Credit
          lc_z             TYPE char1      VALUE 'Z',
          lc_tax_ty        TYPE rvari_vnam VALUE 'TAX_TY',
          lc_parvw         TYPE parvw      VALUE 'AG',
          lc_header        TYPE posnr      VALUE '000000'. " Item number of the SD document

DATA:lst1_e1edk01    TYPE e1edk01,      " Header general data
     lst1_e1edp26    TYPE e1edp26,      " Header general data
     lst1_e1edp04    TYPE e1edp04,      " Header general data
     lst1_e1edk03    TYPE e1edk03,      " Header general data
     lst1_e1edp26_t  TYPE e1edp26,      " Header general data
     lst1_e1edk02    TYPE e1edk02,      " Document header reference data
     lst1_e1edk04    TYPE e1edk04,      " IDoc: Document header taxes
     lst1_e1edk14    TYPE e1edk14,      " IDoc: Document header taxes
     lst1_e1edka1    TYPE e1edka1,      " IDoc: Document Header Partner Information
     lst1_e1edp01    TYPE e1edp01,      " IDoc: Document Item General Data
     lst1_z1qtc_item TYPE z1qtc_item,   " Additional field for Item
     lr1_fkart       TYPE ltt_fkart,    " Billing Doc type posnr
     lr1_fkart_xb    TYPE ltt_fkart,    " Billing Doc type for xblnr
     lr1_fkart_m     TYPE ltt_fkart,    " Negative sign for Billing Doc type
     lv_lastday      TYPE sy-datum,     " last day of month
     lv_tabix        TYPE sy-tabix,     " Index number
     lst1_edidd      TYPE edidd.        " Data record (IDoc)

DATA :li1_constant TYPE zcat_constants,    "Constant Values
      lv_zterm     TYPE dzterm,
      li_top       TYPE STANDARD TABLE OF vtopis. "ED2K925554 FMM-7286 1/13/2022 MIMMADISET

CLEAR:lst1_e1edk01,lst1_e1edp26,lst1_e1edp26_t,lst1_e1edk02,
      lst1_e1edk04,lst1_e1edk14,lst1_e1edka1,lst1_e1edp04,lst1_z1qtc_item,
      lv_lastday,lv_tabix,lst1_edidd.
FREE:lr1_fkart[],lr1_fkart_xb[],lr1_fkart_m[].
* Get the last line from EDIDD table and modify the same line if required
* Otherwise append new line to populate Custom header and item segments
DESCRIBE TABLE int_edidd LINES DATA(lv1_line).

READ TABLE int_edidd ASSIGNING FIELD-SYMBOL(<lst1_edidd>) INDEX lv1_line.

*---Check the Constant table before going to the actual logiC.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_i0397       "Development ID
  IMPORTING
    ex_constants = li1_constant. "Constant Values
*   Loop to populate range table / variables
LOOP AT li1_constant INTO DATA(lst1_constant).
  CASE lst1_constant-param1.
    WHEN lc_fkart.
      lst1_fkart-sign = lst1_constant-sign .
      lst1_fkart-option = lst1_constant-opti.
      lst1_fkart-low = lst1_constant-low.
      APPEND lst1_fkart TO lr1_fkart."" Billing Doc type for POSNR
      CLEAR lst1_fkart.
    WHEN lc_fkart_xb.
      lst1_fkart-sign = lst1_constant-sign .
      lst1_fkart-option = lst1_constant-opti.
      lst1_fkart-low = lst1_constant-low.
      APPEND lst1_fkart TO lr1_fkart_xb."" Billing Doc type for XBLNR
      CLEAR lst1_fkart.
    WHEN lc_fkart_m.
      lst1_fkart-sign = lst1_constant-sign .
      lst1_fkart-option = lst1_constant-opti.
      lst1_fkart-low = lst1_constant-low.
      APPEND lst1_fkart TO lr1_fkart_m."" Billing Doc type for Negatvie sign
      CLEAR lst1_fkart.
    WHEN lc_tax_ty.
      DATA(lv_tax_ty) = lst1_constant-low.
  ENDCASE.
ENDLOOP.

CASE <lst1_edidd>-segnam.

  WHEN lc1_e1edk01 OR lc1_z1qtc_header. " 'E1EDK01'.
*   Obtain details in work area.
    READ TABLE int_edidd ASSIGNING <lst1_edidd> WITH KEY segnam = lc1_e1edk01.
    IF sy-subrc = 0.
      lst1_e1edk01 = <lst1_edidd>-sdata.
      IF lst1_e1edk01-zterm IS NOT INITIAL.
** Boc ED2K925554 FMM-7286 1/13/2022 MIMMADISET
*        SELECT SINGLE * FROM t052 INTO @DATA(ls_t052)
*          WHERE zterm = @lst1_e1edk01-zterm.
*        IF sy-subrc = 0.
** Get last day of the month
*          CALL FUNCTION 'LAST_DAY_OF_MONTHS'
*            EXPORTING
*              day_in            = xvbdkr-fkdat
*            IMPORTING
*              last_day_of_month = lv_lastday "Last day of the month
*            EXCEPTIONS
*              day_in_no_date    = 1
*              OTHERS            = 2.
*          IF sy-subrc = 0.
***Derive the ZTAG1 Days by adding to Last day of the month of billing Date
*            ADD ls_t052-ztag1 TO lv_lastday.
*            CONCATENATE lv_lastday+0(4) lc_col lv_lastday+4(2) lc_col
*            lv_lastday+6(2) INTO DATA(lv_date).
*      *- Payment term calc date
        CLEAR:lv_zterm.
        REFRESH:li_top[].
        lv_zterm = lst1_e1edk01-zterm.
        CALL FUNCTION 'SD_PRINT_TERMS_OF_PAYMENT'
          EXPORTING
            bldat                        = xvbdkr-fkdat
            terms_of_payment             = lv_zterm
          TABLES
            top_text                     = li_top
          EXCEPTIONS
            terms_of_payment_not_in_t052 = 1
            OTHERS                       = 2.

        IF sy-subrc <> 0.
* Implement suitable error handling here
        ELSE.
          READ TABLE li_top INTO DATA(lst_top) INDEX 1.
          IF sy-subrc = 0.
            CONCATENATE lst_top-hdatum+0(4) lc_col lst_top-hdatum+4(2) lc_col
            lst_top-hdatum+6(2) INTO DATA(lv_date).
            lst1_e1edk01-zterm = lv_date.
            <lst1_edidd>-sdata = lst1_e1edk01.
          ENDIF.
        ENDIF.
** Eoc ED2K925554 FMM-7286 1/13/2022 MIMMADISET
      ENDIF.
    ENDIF.
  WHEN lc1_e1edk02. " E1EDK02
    lst1_e1edk02 = <lst1_edidd>-sdata.
*  Mandatory if the invocie type is ZCR or ZS1
    IF xvbdkr-fkart IN lr1_fkart AND lr1_fkart IS NOT INITIAL.
      IF lst1_e1edk02-qualf = lc1_qualf_009. "'009'.
        IF xvbdkr-fkart = lc_fkart_zcr AND xvbdkr-xblnr IS NOT INITIAL.
          " there are multiple lines in the invoice and multiple
          "credit memos are created for same invoice and we need to send the count
          SELECT vbelv,posnv,vbeln,posnn,vbtyp_n
            FROM vbfa
            INTO TABLE @DATA(lt_vbfa)
            WHERE vbelv = @xvbdkr-xblnr   "Reference doc number
              AND vbtyp_n = @lc1_vbtyp_o. "Credit memo
          IF sy-subrc = 0.
            SORT lt_vbfa BY vbeln.
            DELETE ADJACENT DUPLICATES FROM lt_vbfa COMPARING vbeln.
            DESCRIBE TABLE lt_vbfa LINES DATA(lv_max_count).
            lst1_e1edk02-posnr = lv_max_count.
            CONDENSE lst1_e1edk02-posnr NO-GAPS.
            <lst1_edidd>-sdata = lst1_e1edk02.
          ENDIF.
          CLEAR:lv_max_count.
          REFRESH:lt_vbfa[].
        ELSE.
          lst1_e1edk02-posnr = 1.
          CONDENSE lst1_e1edk02-posnr NO-GAPS.
          <lst1_edidd>-sdata = lst1_e1edk02.
        ENDIF.
      ENDIF.
    ENDIF.
    IF xvbdkr-fkart IN lr1_fkart_xb AND lr1_fkart_xb IS NOT INITIAL.
** Not required for ZF2 invoice type.
      IF lst1_e1edk02-qualf = lc1_qualf_087. "'087'.
        lst1_e1edk02-belnr = space.
        <lst1_edidd>-sdata = lst1_e1edk02.
      ENDIF.
    ENDIF.
    CLEAR lst1_e1edk02.
  WHEN lc1_e1edk03. " E1EDK03
    lst1_e1edk03 = <lst1_edidd>-sdata.
    IF lst1_e1edk03-iddat = lc1_qualf_011 OR
       lst1_e1edk03-iddat = lc1_qualf_026.
      "Logic to populate the contract start date and end date.
      LOOP AT int_edidd INTO DATA(ls_contract) WHERE segnam = lc1_e1edk02.
        lst1_e1edk02 = ls_contract-sdata.
        IF lst1_e1edk02-qualf = lc1_qualf_002. "'002'.
          DATA(lv_contract) = lst1_e1edk02-belnr.
          EXIT.
        ENDIF.
        CLEAR:lst1_e1edk02.
      ENDLOOP.
      IF lv_contract IS NOT INITIAL.
        IF xvbdkr-fkart = lc_zcr.
          "Read the contract based on credit memo
          SELECT SINGLE vbelv FROM vbfa
                 INTO @DATA(lv_vbelv)
                 WHERE vbeln = @lv_contract
                 AND vbtyp_v = @lc_g.
          IF sy-subrc = 0.
            "Pass to contract variable
            lv_contract = lv_vbelv.
          ENDIF.
        ENDIF.
        SELECT SINGLE vbeln,   " Sales Document
         vposn,   " Sales Document Item
         vbegdat, " Contract start date
         venddat      " Contract end date
         FROM veda    " Contract Data
         INTO @DATA(ls_veda)
         WHERE vbeln EQ @lv_contract
         AND vposn = @lc_header.
        IF sy-subrc = 0.
          IF lst1_e1edk03-iddat = lc1_qualf_011.
            lst1_e1edk03-datum =  ls_veda-venddat. "End date
            <lst1_edidd>-sdata = lst1_e1edk03.
          ELSEIF lst1_e1edk03-iddat = lc1_qualf_026.
            lst1_e1edk03-datum =  ls_veda-vbegdat. "Start date
            <lst1_edidd>-sdata = lst1_e1edk03.
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR:lv_contract,lv_vbelv,lst1_e1edk03.
      "End logic
    ENDIF.
  WHEN lc1_e1edk14. " E1EDK14
*** Read the company code.
    lst1_e1edk14 = <lst1_edidd>-sdata.
    IF lst1_e1edk14-qualf = lc1_qualf_008. "'008'.
      SELECT document,
                 doc_line_number,
                 buyer_reg,
                 seller_reg,     " Seller VAT Registration Number
                 invoice_desc    " Invoice Description
            FROM /idt/d_tax_data " Tax Data
            INTO TABLE @DATA(i_tax_data)
            WHERE company_code = @lst1_e1edk14-orgid
*            AND   fiscal_year = @lc_gjahr
            AND   document_type = @lc_doc_type
            AND   document = @dobject-objky+0(10).
      IF sy-subrc NE 0.
**If IDT table blank,
**then pass the BP number from VBAK-KUNNR to
**DFKKBPTAXNUM-PARTNER and get the value of TAXNUM where TAXTYPE = HU0"
        CLEAR:lst1_e1edka1.
        LOOP AT int_edidd INTO DATA(ls_parvw) WHERE segnam = lc1_e1edka1.
          lst1_e1edka1 = ls_parvw-sdata.
          IF lst1_e1edka1-parvw = lc_parvw.
            DATA(lv_payer) = lst1_e1edka1-partn.
            EXIT.
          ENDIF.
        ENDLOOP.
        SELECT * FROM dfkkbptaxnum
           INTO TABLE @DATA(li_dfkkbptaxnum)
           WHERE partner = @lv_payer"st_header-bill_cust_number "li_i_vbpa-kunnr
           AND    taxtype = @lc_hu0.
        IF li_dfkkbptaxnum[] IS NOT INITIAL.
          READ TABLE li_dfkkbptaxnum INTO DATA(lst_dfkkbptaxnum) INDEX 1.
          IF lst_dfkkbptaxnum IS NOT INITIAL.
            SELECT SINGLE * FROM t001z
              INTO @DATA(ls_t001z)
              WHERE bukrs = @lst1_e1edk14-orgid.
            IF sy-subrc = 0.
              IF ls_t001z-paval CS lc_col.
                "Boc ED2K925554 FMM-7286 1/13/2022 MIMMADISET
*                SPLIT ls_t001z-paval AT lc_col
*                INTO lst1_e1edk04-ktext DATA(lv_two).
                lst1_e1edk04-ktext = ls_t001z-paval.
                "Boc ED2K925554 FMM-7286 1/13/2022 MIMMADISET
              ELSE.
                lst1_e1edk04-ktext = ls_t001z-paval.
              ENDIF.
              CONCATENATE lv_tax_ty lst1_e1edk04-ktext
              INTO lst1_e1edk04-ktext.
              CONDENSE lst1_e1edk04-ktext.
              CLEAR:lv_tax_ty.
            ENDIF.
            lst1_e1edk04-msatz = lst_dfkkbptaxnum-taxnum.
** Check segment e1edk04 exist or not
            READ TABLE int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd_temp2>)
            WITH KEY segnam = lc1_e1edk04 . " 'E1EDK04'.
            IF sy-subrc NE 0." If not add new segment
              LOOP AT int_edidd ASSIGNING <lst_edidd_temp2>
               WHERE segnam = lc1_e1edk03 OR segnam = lc1_e1edk05. " 'E1EDP01'.
                lv_tabix = sy-tabix.
              ENDLOOP.
              IF sy-subrc = 0.
                lv_tabix =  lv_tabix + 1.
              ENDIF.
              lst1_edidd-segnam = lc1_e1edk04 . " 'E1EDK04'.
              lst1_edidd-sdata = lst1_e1edk04 .
              INSERT lst1_edidd INTO int_edidd INDEX lv_tabix.  "Adding new segment
            ELSE.
** If already exist,update the new values in KTEXT and MSATZ
              <lst_edidd_temp2>-sdata = lst1_e1edk04 .
            ENDIF.
            CLEAR:lst1_e1edk04,lv_tabix,li_dfkkbptaxnum.
          ENDIF.
          CLEAR:lv_payer.
        ENDIF.
      ELSE.
        IF i_tax_data IS NOT INITIAL.
          SORT i_tax_data BY document doc_line_number.
*--*tax id
          DATA(li_tax_seller) = i_tax_data.
          SORT li_tax_seller BY seller_reg.
          DELETE li_tax_seller WHERE seller_reg IS INITIAL.
          DELETE ADJACENT DUPLICATES FROM li_tax_seller COMPARING seller_reg.
          SORT li_tax_seller BY document doc_line_number.
          READ TABLE li_tax_seller INTO DATA(lst_tax_seller) INDEX 1.
**Customer Tax ID
          DATA(li_tax_data) = i_tax_data.
          SORT li_tax_data BY document doc_line_number.
          DELETE li_tax_data WHERE buyer_reg IS INITIAL.
          DELETE ADJACENT DUPLICATES FROM li_tax_data COMPARING document doc_line_number.
          READ TABLE li_tax_data INTO DATA(lst_tax_buy) INDEX 1.
          lst1_e1edk04-msatz = lst_tax_buy-buyer_reg.
          lst1_e1edk04-ktext = lst_tax_seller-seller_reg.
** Check segment e1edk04 exist or not
          READ TABLE int_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd_temp1>)
          WITH KEY segnam = lc1_e1edk04 . " 'E1EDK04'.
          IF sy-subrc NE 0." If not add new segment
            LOOP AT int_edidd ASSIGNING <lst_edidd_temp1>
             WHERE segnam = lc1_e1edk03 OR segnam = lc1_e1edk05. " 'E1EDP01'.
              lv_tabix = sy-tabix.
            ENDLOOP.
            IF sy-subrc = 0.
              lv_tabix =  lv_tabix + 1.
            ENDIF.
            lst1_edidd-segnam = lc1_e1edk04 . " 'E1EDK04'.
            lst1_edidd-sdata = lst1_e1edk04 .
            INSERT lst1_edidd INTO int_edidd INDEX lv_tabix.  "Adding new segment
          ELSE.
** If already exist,update the new values in KTEXT and MSATZ
            <lst_edidd_temp1>-sdata = lst1_e1edk04 .
          ENDIF.
          CLEAR:lst1_edidd,lst1_e1edk04,lv_tabix.
        ENDIF. " IF lst_edidd IS NOT INITIAL
      ENDIF.
      REFRESH:i_tax_data.
    ENDIF.
  WHEN lc1_e1edp19.
    "Mandatory for document types ZCR and ZS1.
    IF xvbdkr-fkart IN lr1_fkart AND lr1_fkart IS NOT INITIAL.
      LOOP AT int_edidd ASSIGNING <lst1_edidd>
      WHERE segnam = lc1_z1qtc_item.
      ENDLOOP. "
      IF sy-subrc = 0.
        lst1_z1qtc_item = <lst1_edidd>-sdata.
        "Read posex value from lc1_e1edp01 segment
        LOOP AT int_edidd INTO lst1_edidd WHERE segnam = lc1_e1edp01.
          lst1_e1edp01 = lst1_edidd-sdata.
          DATA(lv_posex_it) = lst1_e1edp01-posex.
        ENDLOOP.
        SELECT SINGLE posnv FROM vbfa
          INTO @DATA(lv_posnv)
          WHERE vbeln = @dobject-objky+0(10)
          AND posnn = @lv_posex_it
          AND vbelv = @xvbdkr-xblnr
          AND vbtyp_v = @lc_vbtyp_m.
        IF sy-subrc = 0.
          lst1_z1qtc_item-zposex_e = lv_posnv.
          <lst1_edidd>-sdata = lst1_z1qtc_item.
        ENDIF.
      ENDIF.
      CLEAR:lv_posex_it,lst1_z1qtc_item,lv_posnv.
    ENDIF.
  WHEN lc1_e1edp01.
    .
  WHEN lc1_e1edp04. "E1EDP04
    lst1_e1edp04 = <lst1_edidd>-sdata.
**Vat Percent  Divide the value by 100.
    IF lst1_e1edp04-msatz IS NOT INITIAL.
      lst1_e1edp04-msatz = lst1_e1edp04-msatz / 100.
      CONDENSE lst1_e1edp04-msatz NO-GAPS.
      <lst1_edidd>-sdata = lst1_e1edp04.
    ENDIF.
** Multiply with -1 when document type is ZCR or ZS1
    IF xvbdkr-fkart IN lr1_fkart_m
       AND lr1_fkart_m IS NOT INITIAL
       AND lst1_e1edp04-mwsbt IS NOT INITIAL.
      lst1_e1edp04-mwsbt = lst1_e1edp04-mwsbt * -1.
      CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
        CHANGING
          value = lst1_e1edp04-mwsbt.
      CONDENSE lst1_e1edp04-mwsbt NO-GAPS.
      <lst1_edidd>-sdata = lst1_e1edp04.
    ENDIF.
** Below loop for read the net amount and identify the
** Gross amount qualifier index number.
    LOOP AT int_edidd ASSIGNING FIELD-SYMBOL(<fst1_edidd>)
      WHERE segnam = lc1_e1edp26
         OR segnam = lc1_e1edp01.
      DATA(lv_index) = sy-tabix.
      IF <fst1_edidd>-segnam = lc1_e1edp26.
        lst1_e1edp26_t = <fst1_edidd>-sdata.
        IF lst1_e1edp26_t-qualf = lc1_qualf_002. "Net Amount
*          OR lst1_e1edp26_t-qualf = lc1_qualf_001. "Unit price
**** Multiply with -1 when document type is ZCR or ZS1
          IF xvbdkr-fkart IN lr1_fkart_m
            AND lr1_fkart_m IS NOT INITIAL
            AND lst1_e1edp26_t-betrg IS NOT INITIAL.
            IF lst1_e1edp26_t-betrg CS lc_col.
              "Already negative sign exit
            ELSE.
              lst1_e1edp26_t-betrg = lst1_e1edp26_t-betrg * -1.
              CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
                CHANGING
                  value = lst1_e1edp26_t-betrg.
              CONDENSE lst1_e1edp26_t-betrg NO-GAPS.
              <fst1_edidd>-sdata = lst1_e1edp26_t.
            ENDIF.
          ENDIF.
        ENDIF.
        IF lst1_e1edp26_t-qualf = lc1_qualf_002. "'002'. "Net Amount
          DATA(lv_bet_002) = lst1_e1edp26_t-betrg.
        ENDIF.
        IF lst1_e1edp26_t-qualf = lc1_qualf_003. "'003'.
          DATA(lv_tab_003) = lv_index. "Finding the index no to update the newgross amount
        ENDIF.
        CLEAR:lst1_e1edp26_t.
      ENDIF.
      IF <fst1_edidd>-segnam = lc1_e1edp01.
        lst1_e1edp01 = <fst1_edidd>-sdata.
        "Quantity of product or service. The value sent to NAV system for ZCR and ZS1 should be -ve.
        IF xvbdkr-fkart IN lr1_fkart_m
        AND lr1_fkart_m IS NOT INITIAL
        AND lst1_e1edp01-menge IS NOT INITIAL.
          IF lst1_e1edp01-menge CS lc_col.
            "Already negative sign exist
          ELSE.
            lst1_e1edp01-menge = lst1_e1edp01-menge * -1.
            CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
              CHANGING
                value = lst1_e1edp01-menge.
            CONDENSE lst1_e1edp01-menge NO-GAPS.
            <fst1_edidd>-sdata = lst1_e1edp01.
          ENDIF.
        ENDIF.
        CLEAR:lst1_e1edp01,lv_bet_002,lv_tab_003.
      ENDIF.
    ENDLOOP.
    CLEAR:lst1_edidd,lst1_e1edp26_t.
**If tabix number found for gross amount and update the below logic in the segment
    READ TABLE int_edidd ASSIGNING FIELD-SYMBOL(<lst2_edidd>) INDEX lv_tab_003.
    IF sy-subrc = 0.
      lst1_e1edp26_t = <lst2_edidd>-sdata.
      IF lst1_e1edp26_t-qualf = lc1_qualf_003 AND <lst2_edidd>-segnam = lc1_e1edp26.
*Sum of Row containing values for VAT Amount and Net Amount
*gross amount = Sum of Qualifier '002' and MWSBT"
        lst1_e1edp26_t-betrg = lv_bet_002 + lst1_e1edp04-mwsbt.
        IF lst1_e1edp26_t-betrg CS lc_col.  "Adding the sign before the amount
          CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
            CHANGING
              value = lst1_e1edp26_t-betrg.
        ENDIF.
        CONDENSE lst1_e1edp26_t-betrg NO-GAPS.
        <lst2_edidd>-sdata = lst1_e1edp26_t.
      ENDIF.
    ENDIF.
    CLEAR:lv_bet_002,lst1_edidd,lst1_e1edp26,lst1_e1edp04,lv_tab_003,lst1_e1edp04.
  WHEN OTHERS.
ENDCASE.
