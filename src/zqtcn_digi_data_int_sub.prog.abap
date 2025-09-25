*&---------------------------------------------------------------------*
*&  Include           ZQTC_DIGI_DATA_INT_SUB
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_DF_DIGITAL_ENT_DATA_INT
* PROGRAM DESCRIPTION: Report to upload a text file onto application
*                      layer for Digital Entitlement Data Interface
*                      sent to TIBCO                                   *
* DEVELOPER:           APATNAIK(Alankruta Patnaik)
* CREATION DATE:      12/27/2016
* OBJECT ID:          I0342
* TRANSPORT NUMBER(S):ED2K903899
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K906458
* REFERENCE NO:  ERP-2509
* DEVELOPER:     Pavan Bandlapalli(PBANDLAPAL)
* DATE:          01-Jun-2017
* DESCRIPTION: To change the Initial Shipping Date(isminitshipdate) to
* publication date(ismpubldate) and Item number in the output should be
* just an incremental number.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
* Subroutine to fetch data
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_data CHANGING fp_i_vbrk          TYPE tt_vbrk
                           fp_i_but0id        TYPE tt_but0id
                           fp_i_vbak          TYPE tt_vbak
                           fp_i_vbpa          TYPE tt_vbpa
                           fp_i_vbfa          TYPE tt_vbfa
                           fp_i_vbap          TYPE tt_vbap
                           fp_i_vbkd          TYPE tt_vbkd
                           fp_i_jptidcdassign TYPE tt_jptidcdassign
                           fp_i_mara          TYPE tt_mara
                           fp_i_but050        TYPE tt_but050
                           fp_i_adrc          TYPE tt_adrc
                           fp_i_adr6          TYPE tt_adr6.

*Local internal table declaration
  DATA: li_vbfa          TYPE tt_vbfa,
        li_vbpa          TYPE tt_vbpa,
        li_vbap          TYPE tt_vbap,
        li_jptidcdassign TYPE tt_jptidcdassign,
        li_adrc          TYPE tt_adrc.

  CLEAR fp_i_vbrk.

  SELECT vbeln  "Billing Document number
         fkart  "Billing Document type
         fkdat  "Billing Date
         netwr  "Net Value
      FROM vbrk " Billing Document: Header Data
      INTO TABLE fp_i_vbrk
      WHERE  vbeln IN s_vbeln
      AND   fkart  IN s_fkart
      AND   fkdat  IN s_fkdat.

  IF sy-subrc IS INITIAL.
    SORT i_vbrk BY vbeln.

*Selection from VBFA
    SELECT vbelv   " Preceding sales and distribution document
           posnv   " Preceding item of an SD document
           vbeln   " Subsequent sales and distribution document
           posnn   " Subsequent item of an SD document
           vbtyp_n " Document category of subsequent document
           vbtyp_v " Document category of preceding SD document
      FROM vbfa    " Sales Document Flow
      INTO TABLE fp_i_vbfa
      FOR ALL ENTRIES IN fp_i_vbrk
      WHERE vbeln EQ fp_i_vbrk-vbeln.

    IF sy-subrc IS  INITIAL.
      li_vbfa[] = fp_i_vbfa[].
      SORT fp_i_vbfa BY vbelv.
      DELETE ADJACENT DUPLICATES FROM li_vbfa
      COMPARING vbelv.

      IF li_vbfa IS NOT INITIAL.

*Selection from VBKD
        SELECT vbeln " Sales and Distribution Document Number
               bstkd " Customer purchase order number
          FROM vbkd  " Sales Document: Business Data
          INTO TABLE fp_i_vbkd
          FOR ALL ENTRIES IN li_vbfa
          WHERE vbeln     EQ li_vbfa-vbelv .

        IF sy-subrc IS INITIAL.
*          SORT fp_i_vbfa BY vbelv.
          SORT fp_i_vbkd BY vbeln.
        ENDIF. " IF sy-subrc IS INITIAL

*selection from vbap
        SELECT vbeln " Sales Document
               posnr " Sales Document Item
               matnr " Material Number
        FROM vbap    " Sales Document: Item Data
        INTO TABLE fp_i_vbap
        FOR ALL ENTRIES IN li_vbfa
        WHERE vbeln     EQ li_vbfa-vbelv
        AND   matnr     IN s_matnr.

        IF sy-subrc IS INITIAL.
          SORT fp_i_vbap BY vbeln
                         posnr.
*
          li_vbap[] = fp_i_vbap[].
          DELETE ADJACENT DUPLICATES FROM li_vbap[]
          COMPARING vbeln
                    posnr.

          IF li_vbap[] IS NOT INITIAL.

*           Selection from jptidcdassign
            SELECT matnr         " Material Number
                   idcodetype    " Identification Code
                   identcode     " Type of Identification Code
              FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
              INTO TABLE fp_i_jptidcdassign
              FOR ALL ENTRIES IN li_vbap
              WHERE matnr = li_vbap-matnr
              AND   idcodetype IN (c_oclc,c_wisp).

            IF sy-subrc IS INITIAL.
              SORT i_jptidcdassign BY idcodetype.

              li_jptidcdassign[] = fp_i_jptidcdassign[].
              DELETE li_jptidcdassign WHERE idcodetype NE c_oclc.

              SORT li_jptidcdassign BY matnr.
              DELETE ADJACENT DUPLICATES FROM li_jptidcdassign COMPARING matnr.

              IF li_jptidcdassign[] IS NOT INITIAL.
*Selection from mara
                SELECT matnr        " Material Number
                       bismt        " Old material number
                       ismtitle     " Title
                       ismsubtitle1     " Subtitle 1
* Begin of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
*                       isminitshipdate  " Initial Shipping Date
                        ismpubldate      " Publication Date
* End of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
                       FROM mara    " General Material Data
                       INTO TABLE fp_i_mara
                       FOR ALL ENTRIES IN li_jptidcdassign
                       WHERE matnr EQ li_jptidcdassign-matnr.
                IF sy-subrc IS INITIAL.
                  SORT fp_i_mara BY matnr.
                ENDIF. " IF sy-subrc IS INITIAL
              ENDIF. " IF li_jptidcdassign[] IS NOT INITIAL
            ENDIF. " IF sy-subrc IS INITIAL
          ENDIF. " IF li_vbap[] IS NOT INITIAL
        ENDIF. " IF sy-subrc IS INITIAL

*Selection from VBAK
        SELECT   vbeln "sales Document Number
                 audat "Order Date
                 kunnr " Sold-to party
            FROM vbak  " Sales Document: Header Data
            INTO TABLE fp_i_vbak
            FOR ALL ENTRIES IN li_vbfa
          WHERE vbeln EQ li_vbfa-vbelv.

        IF sy-subrc IS INITIAL.
          SORT fp_i_vbak BY vbeln.

*Selection from VBPA

          SELECT vbeln     " Sales and Distribution Document Number
                 posnr     " Item number of the SD document
                 parvw     " Partner Function
                 kunnr     " Customer Number
                 adrnr     " Address
                 FROM vbpa " Sales Document: Partner
                 INTO TABLE fp_i_vbpa
                 FOR ALL ENTRIES IN fp_i_vbak
                 WHERE vbeln EQ fp_i_vbak-vbeln
                   AND kunnr IN s_kunnr
                   AND parvw EQ c_parvw_sh.
          IF sy-subrc IS INITIAL.
            SORT fp_i_vbpa BY kunnr parvw.
            li_vbpa[] = fp_i_vbpa[].
            DELETE ADJACENT DUPLICATES FROM li_vbpa
            COMPARING kunnr.
            IF li_vbpa[] IS NOT INITIAL.
              SELECT  partner     " Business Partner Number
                      type        " Identification Type
                      idnumber    " Identification Number
                      FROM but0id " BP: ID Numbers
                      INTO TABLE fp_i_but0id
                      FOR ALL ENTRIES IN li_vbpa
                      WHERE partner EQ li_vbpa-kunnr.
              IF sy-subrc IS INITIAL.
                SORT fp_i_but0id BY partner.
                DELETE fp_i_but0id WHERE type NE c_type.
              ENDIF. " IF sy-subrc IS INITIAL

*             BP relationships/role definitions: General data
              SELECT r~relnr      " BP Relationship Number
                     r~partner1   " Business Partner Number
                     r~partner2   " Business Partner Number
                     g~name1_text
                FROM but050 AS r INNER JOIN
                     but000 AS g
                  ON g~partner EQ r~partner2
                INTO TABLE fp_i_but050
                 FOR ALL ENTRIES IN li_vbpa
               WHERE r~partner1  EQ li_vbpa-kunnr
                 AND r~reltyp    EQ c_reltyp_cnt
                 AND r~date_to   GE sy-datum
                 AND r~date_from LE sy-datum.
              IF sy-subrc EQ 0.
                SORT fp_i_but050 BY partner1.
              ENDIF.

*Get Partner Address Details
              SORT fp_i_vbpa BY adrnr.
              CLEAR li_vbpa.
              li_vbpa[] = i_vbpa[].
              DELETE ADJACENT DUPLICATES FROM li_vbpa
              COMPARING adrnr.
              IF li_vbpa IS NOT INITIAL.

*Selection from ADRC
                SELECT  addrnumber " Address number
                        name1      " Name 1
                        name2      " Name 2
                        city1      " City
                        post_code1 " City postal code
                        street     " Street
                        region     " Region (State, Province, County)
                        FROM adrc  " Addresses (Business Address Services)
                        INTO TABLE fp_i_adrc
                        FOR ALL ENTRIES IN li_vbpa
                        WHERE addrnumber EQ li_vbpa-adrnr.
                IF sy-subrc IS INITIAL.
                  SORT fp_i_adrc BY addrnumber.
*                    Get Email Id
                  li_adrc[] = fp_i_adrc[].
                  DELETE ADJACENT DUPLICATES FROM li_adrc
                  COMPARING addrnumber.
                  IF li_adrc[] IS NOT INITIAL.

*Selection from ADR6
                    SELECT  addrnumber " Address number
                            smtp_addr  " E-Mail Address
                            FROM adr6  " E-Mail Addresses (Business Address Services)
                            INTO TABLE fp_i_adr6
                            FOR ALL ENTRIES  IN li_adrc
                            WHERE addrnumber EQ li_adrc-addrnumber.
                    IF sy-subrc IS INITIAL.
                      SORT fp_i_adr6 BY addrnumber.
                    ENDIF. " IF sy-subrc IS INITIAL
                  ENDIF. " IF li_adrc[] IS NOT INITIAL
                ENDIF. " IF sy-subrc IS INITIAL
              ENDIF. " IF li_vbpa IS NOT INITIAL
            ENDIF. " IF li_vbpa[] IS NOT INITIAL
          ENDIF. " IF sy-subrc IS INITIAL
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF li_vbfa IS NOT INITIAL
    ENDIF . " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
* Subroutine to process the data for final table
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_data USING    fp_i_vbrk          TYPE tt_vbrk
                             fp_i_but0id        TYPE tt_but0id
                             fp_i_vbak          TYPE tt_vbak
                             fp_i_vbap          TYPE tt_vbap
                             fp_i_vbkd          TYPE tt_vbkd
                             fp_i_mara          TYPE tt_mara
                             fp_i_but050        TYPE tt_but050
                             fp_i_adrc          TYPE tt_adrc
                             fp_i_adr6          TYPE tt_adr6
                    CHANGING fp_i_final         TYPE tt_final
                             fp_i_jptidcdassign TYPE tt_jptidcdassign
                             fp_i_vbpa          TYPE tt_vbpa
                             fp_i_vbfa          TYPE tt_vbfa
  .


*====================================================================*
*  Local Variable
*====================================================================*
* Data declaration
  DATA: lst_final TYPE ty_final,
        lv_vbau   TYPE string,
        lv_incr_count TYPE posnr_va,    " Insert ERP-2509
        lv_flag   TYPE char1. " Flag of type CHAR1


  SORT fp_i_jptidcdassign BY matnr idcodetype.
  SORT fp_i_vbfa          BY vbelv.
  SORT fp_i_vbpa          BY vbeln posnr.

  CLEAR lv_incr_count.
  LOOP AT fp_i_vbap ASSIGNING FIELD-SYMBOL(<lst_vbap>).
    CLEAR: lst_final,
           lv_flag.
* Begin of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
*    lst_final-posnr = <lst_vbap>-posnr.
* End of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
*      No values to be chosen from vbfa for i_final
    READ TABLE fp_i_vbfa ASSIGNING FIELD-SYMBOL(<lst_vbfa>)
          WITH KEY vbelv = <lst_vbap>-vbeln
    BINARY SEARCH.

    IF sy-subrc IS INITIAL AND <lst_vbfa> IS ASSIGNED.

***Read table to populate invoice number and billing date
      READ TABLE fp_i_vbrk ASSIGNING FIELD-SYMBOL(<lst_vbrk>)
      WITH KEY vbeln = <lst_vbfa>-vbeln
      BINARY SEARCH.

      IF sy-subrc IS INITIAL  AND <lst_vbrk> IS ASSIGNED.
*         Populate Invoice Number and Billing date
        lst_final-vbeln = <lst_vbrk>-vbeln.
        lst_final-fkdat = <lst_vbrk>-fkdat.

**To check whether document category is C or G

        CASE <lst_vbfa>-vbtyp_v.
          WHEN c_vbtyp_c  "'C'
            OR c_vbtyp_g. "'G'.

**Read table vbkd to populate
            READ TABLE fp_i_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>)
            WITH KEY vbeln = <lst_vbfa>-vbelv
            BINARY SEARCH.
            IF sy-subrc EQ 0 AND <lst_vbkd> IS ASSIGNED.

*               Populate purchase order document number
              lst_final-bstkd = <lst_vbkd>-bstkd.
            ENDIF. " IF sy-subrc EQ 0 AND <lst_vbkd> IS ASSIGNED

            READ TABLE fp_i_vbak ASSIGNING FIELD-SYMBOL(<lst_vbak>)
            WITH KEY vbeln = <lst_vbfa>-vbelv
            BINARY SEARCH.

            IF  sy-subrc EQ 0
            AND <lst_vbak> IS ASSIGNED.
*               Populate Document date and Sales doc number
              lst_final-audat = <lst_vbak>-audat.
              CONCATENATE <lst_vbak>-vbeln
                          <lst_vbak>-audat
              INTO         lv_vbau.

              lst_final-vbau = lv_vbau.

              READ TABLE fp_i_vbpa ASSIGNING FIELD-SYMBOL(<lst_vbpa>)
              WITH KEY vbeln = <lst_vbap>-vbeln
                       posnr = <lst_vbap>-posnr
              BINARY SEARCH.
              IF sy-subrc NE 0.
                READ TABLE fp_i_vbpa ASSIGNING <lst_vbpa>
                WITH KEY vbeln = <lst_vbap>-vbeln
                         posnr = c_posnr_hdr
                BINARY SEARCH.
              ENDIF.
              IF sy-subrc EQ 0 AND <lst_vbpa> IS ASSIGNED.

*                 Partner function value SH converted to WE, so PARVW= WE is passed here.

                READ TABLE fp_i_but0id ASSIGNING FIELD-SYMBOL(<lst_but0id>)
                WITH KEY partner = <lst_vbpa>-kunnr
                BINARY SEARCH.
                IF sy-subrc EQ 0 AND <lst_but0id> IS ASSIGNED.
*                     Populate ID number into final table
                  lst_final-idnumber = <lst_but0id>-idnumber.

                  IF <lst_but0id>-type EQ c_type. "'ZOCLC'.
                    READ TABLE fp_i_adrc ASSIGNING FIELD-SYMBOL(<lst_adrc>)
                    WITH KEY addrnumber = <lst_vbpa>-adrnr
                    BINARY SEARCH.

                    IF sy-subrc EQ 0 AND <lst_adrc> IS ASSIGNED.
*                         Populate name, city, street,region,postal code
                      CONCATENATE <lst_adrc>-name1
                                  <lst_adrc>-name2
                             INTO lst_final-name1
                        SEPARATED BY space.
                      lst_final-city1      = <lst_adrc>-city1.
                      lst_final-post_code1 = <lst_adrc>-postcode.
                      lst_final-street     = <lst_adrc>-street.
                      lst_final-region     = <lst_adrc>-region.
                    ENDIF. " IF sy-subrc EQ 0 AND <lst_adrc> IS ASSIGNED

                    READ TABLE fp_i_adr6
                    ASSIGNING FIELD-SYMBOL(<lst_adr6>)
                    WITH KEY addrnumber = <lst_adrc>-addrnumber
                    BINARY SEARCH.
                    IF sy-subrc EQ 0 AND <lst_adr6> IS ASSIGNED.
*                         Populate the email address
                      lst_final-smtp_addr = <lst_adr6>-smtp_addr.
                    ENDIF. " IF sy-subrc EQ 0 AND <lst_adr6> IS ASSIGNED

*                   Determine Contact Person's Name
                    READ TABLE fp_i_but050 ASSIGNING FIELD-SYMBOL(<lst_but050>)
                         WITH KEY partner1 =  <lst_vbpa>-kunnr
                         BINARY SEARCH.
                    IF sy-subrc EQ 0.
                      lst_final-cntct_p_name = <lst_but050>-name1_text.
                    ENDIF.
                  ELSE. " ELSE -> IF <lst_but0id>-type EQ c_type
                    lv_flag = c_e.
                  ENDIF. " IF <lst_but0id>-type EQ c_type
                ELSE. " ELSE -> IF sy-subrc EQ 0 AND <lst_but0id> IS ASSIGNED.
                  lv_flag = c_e.
                ENDIF. " IF sy-subrc EQ 0 AND <lst_but0id> IS ASSIGNED
              ELSE. " ELSE -> IF sy-subrc EQ 0 AND <lst_vbpa> IS ASSIGNED
                lv_flag = c_e.
              ENDIF. " IF sy-subrc EQ 0 AND <lst_vbpa> IS ASSIGNED
            ENDIF. " IF sy-subrc EQ 0
        ENDCASE.

        READ TABLE fp_i_jptidcdassign ASSIGNING FIELD-SYMBOL(<lst_jptidcdassign>)
        WITH KEY matnr      = <lst_vbap>-matnr
                 idcodetype = c_oclc
        BINARY SEARCH.
        IF  sy-subrc IS INITIAL.
          lst_final-identcode = <lst_jptidcdassign>-identcode.

          READ TABLE fp_i_jptidcdassign ASSIGNING <lst_jptidcdassign>
          WITH KEY matnr      = <lst_vbap>-matnr
                   idcodetype = c_wisp
          BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-matnr   = <lst_jptidcdassign>-identcode.
          ENDIF.

          READ TABLE fp_i_mara ASSIGNING FIELD-SYMBOL(<lst_mara>)
          WITH  KEY matnr = <lst_vbap>-matnr
          BINARY SEARCH.
          IF sy-subrc IS INITIAL AND <lst_mara> IS ASSIGNED.
            IF lst_final-matnr IS INITIAL.
              lst_final-matnr      = <lst_mara>-bismt.
            ENDIF.
            lst_final-ismtitle     = <lst_mara>-ismtitle.
            lst_final-ismsubtitle1 = <lst_mara>-ismsubtitle1.
* Begin of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
*            lst_final-ismpubldate  = <lst_mara>-initshipdate.  " Initial Shipping Date.
            lst_final-ismpubldate  = <lst_mara>-ismpubldate.  " Initial Shipping Date.
* End of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
          ENDIF. " IF sy-subrc IS INITIAL AND <lst_mara> IS ASSIGNED

          IF lv_flag IS INITIAL.
* Begin of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
            lv_incr_count = lv_incr_count + 1.
            lst_final-posnr = lv_incr_count.
* End of Change by PBANDLAPAL on 06/01/2017 for ERP-2509
            APPEND lst_final TO fp_i_final.
          ENDIF. " IF lv_flag IS INITIAL
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-subrc IS INITIAL AND <lst_vbrk> IS ASSIGNED
    ENDIF. " IF sy-subrc IS INITIAL AND <lst_vbfa> IS ASSIGNED
*    ENDIF. " IF <lst_final> IS ASSIGNED
  ENDLOOP. " LOOP AT i_vbap ASSIGNING FIELD-SYMBOL(<lst_vbap>)
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_DATA
*&---------------------------------------------------------------------*
* Subroutine to upload data
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload_data.
  DATA: lv_data       TYPE string,
        lst_final     TYPE ty_final,
        lv_path_fname TYPE string.

  CONSTANTS: lc_separator TYPE char1  VALUE '|', " Separator of type CHAR1
             lc_0000      TYPE char4  VALUE '0000',
             lc_acc       TYPE char7  VALUE '2002272',
             lc_lang      TYPE char3  VALUE 'ENG',
             lc_01        TYPE char2  VALUE '01',
             lc_usd       TYPE char3  VALUE 'USD',
             lc_03        TYPE char2  VALUE '03',
             lc_15        TYPE char2  VALUE '15',
             lc_dg        TYPE char2  VALUE 'DG',
             lc_val       TYPE char2  VALUE '23',
             lc_blank     TYPE string VALUE ' '.

  CLEAR lv_path_fname.
* Want to make sure filename is not missed in any case if they try to run in background
* in batch job scenario if they give file path in the selection screen.
  CONCATENATE p_path
              v_filenm
              c_underscore
              sy-datum
              c_underscore
              sy-uzeit
              c_extn
              INTO
             lv_path_fname.
  CONDENSE lv_path_fname NO-GAPS.

  OPEN DATASET lv_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc NE 0.
    MESSAGE s100 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0

* Build Header Line
  CONCATENATE 'Party Id'(001)
              'Name'(002)
              'Address Line1'(003)
              'Address Line2'(021)
              'Address Line3'(032)
              'City'(004)
              'State'(005)
              'Province'(033)
              'Postal Code'(006)
              'Country Code'(022)
              'Contact Name'(034)
              'Contact Email'(007)
              'Invoice Number'(008)
              'Invoice Date'(009)
              'Purchase Order Number'(010)
              'Order Date'(011)
              'Line Item Sequence Number'(012)
              'From SAN'(023)
              'Sent Date'(024)
              'Message Number'(013)
              'Default Language of Text'(025)
              'Default Price Type Code'(026)
              'Default Currency Code'(027)
              'Record Reference'(014)
              'Notification Type'(028)
              'Product ID type'(029)
              'ID value'(015)
              'Product ID type'(029)
              'ID value'(015)
              'BarCode'(035)
              'Product Form'(030)
              'Title Type'(031)
              'Title Text'(016)
              'Subtitle'(017)
              'Sequence Number'(036)
              'Contributor Role'(037)
              'Names Before Key'(038)
              'KeyNames'(039)
              'Publishing Role'(040)
              'Publishing Name'(041)
              'Publication Date'(018)
              'Supplier Name'(042)
              'Availability Code'(043)
              'Price TypeCode'(044)
              'Price Amount'(045)
              'Currency Code'(046)

  INTO lv_data
  SEPARATED BY lc_separator. "'|'.

  TRANSFER lv_data TO lv_path_fname.
  CLEAR: lst_final, lv_data.


  LOOP AT i_final INTO lst_final.


    CONCATENATE lst_final-idnumber                "Party id
                lst_final-name1                   "name
                lst_final-street                  "address line1
                lc_blank                          "address line2
                lc_blank                          "address line3
                lst_final-city1                   "city
                lst_final-region                  "state
                lc_blank                          "province
                lst_final-post_code1              "postal code
                lc_0000                           "country code
                lst_final-cntct_p_name            "contact name
                lst_final-smtp_addr               "contact email
                lst_final-vbeln                   "invoice number
                lst_final-fkdat                   "invoice date
                lst_final-bstkd                   "purchase order number
                lst_final-audat                   "order date
                lst_final-posnr                   "item seq num
                lc_acc                            "from san
                sy-datum                          "sent date
                lst_final-vbau                    "msg num
                lc_lang                           "lang of text
                lc_01                             "price type code
                lc_usd                            "currency
                lst_final-identcode               "rec ref
                lc_03                             "notification type
                lc_15                             "product id type
                lst_final-matnr                   "id value
                lc_val                            "prod id type
                lst_final-identcode               "id value
                lc_blank                          "barcode
                lc_dg                             "prod form
                lc_01                             "title type
                lst_final-ismtitle                "title text
                lst_final-ismsubtitle1            "subtitle
                lc_blank                          "Seq num
                lc_blank                          "contributor role
                lc_blank                          "names
                lc_blank                          "key names
                lc_blank                          "publishing role
                lc_blank                          "name
                lst_final-ismpubldate             "pub date
                lc_blank                          "supplier name
                lc_blank                          "ava code
                lc_blank                          "price type code
                lc_blank                          "amt
                lc_blank                          "currency

    INTO lv_data
    SEPARATED BY lc_separator. "'|'.

    TRANSFER lv_data TO lv_path_fname.
    CLEAR: lst_final, lv_data.

  ENDLOOP. " LOOP AT i_final INTO lst_final

* close the file
  CLOSE DATASET lv_path_fname.
  IF sy-subrc IS INITIAL.
    PERFORM f_update_last_run_dt USING sy-datum.
    MESSAGE s003 DISPLAY LIKE c_s.
    LEAVE LIST-PROCESSING.
  ELSE. " ELSE -> IF sy-subrc IS INITIAL AND lv_answer EQ lc_yes
    MESSAGE s088 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.

  ENDIF. " IF sy-subrc IS INITIAL AND lv_answer EQ lc_yes
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REARRANGE_DATE_FORMAT
*&---------------------------------------------------------------------*
* ***Subroutine to reaarange the date
*----------------------------------------------------------------------*
*      -->P_LV_DATE  text
*----------------------------------------------------------------------*
FORM f_rearrange_date_format  USING    fp_lv_date   TYPE sydatum  " System Date
                              CHANGING fp_lv_return TYPE sydatum. " System Date

  CONCATENATE fp_lv_date+0(4)
              fp_lv_date+6(2)
              fp_lv_date+4(2)
              INTO
              fp_lv_return.

  CONDENSE fp_lv_return NO-GAPS.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALUE_REQUEST_FOR_APPL_FILE
*&---------------------------------------------------------------------*
* Subroutine for the F4 help of file path
*----------------------------------------------------------------------*
*      <--P_P_PATH  text
*----------------------------------------------------------------------*
FORM f_value_request_for_appl_file CHANGING fp_p_path TYPE localfile. " Local file for upload/download
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = ' '
    IMPORTING
      serverfile       = v_localfile
    EXCEPTIONS
      canceled_by_user = 1.

  IF sy-subrc <> 0.
    MESSAGE e000 WITH text-053.   "Unable to process
  ENDIF.
  fp_p_path = v_localfile.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VAR_GET_CONST
*&---------------------------------------------------------------------*
*  To Clear all global varibles internal tables work-area
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_var_get_const .
*--------------------------------------------------------------------*
* Clear all global varibles internal tables work-area
*--------------------------------------------------------------------*
  CLEAR:i_vbrk,
        i_but0id,
        i_vbak,
        i_vbpa,
        i_vbfa,
        i_vbap,
        i_vbkd,
        i_adrc,
        i_adr6,
        i_mara,
        i_jptidcdassign,
        i_final,
        v_vbeln,
        v_fkdat,
        v_fkart,
        v_filepath,
        v_filenm,
        v_kunnr,
        v_matnr.
*--------------------------------------------------------------------*
*  get filename
*--------------------------------------------------------------------*

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LAST_RUN_DT
*&---------------------------------------------------------------------*
*  To get the last run date
*----------------------------------------------------------------------*
*      -->FP_LV_END_DATE  text
*----------------------------------------------------------------------*
FORM f_update_last_run_dt USING fp_lv_end_date TYPE dats. " Field of type DATS

  DATA: lst_interface TYPE zcainterface, " Interface run details
        lv_date       TYPE char10.       " Date of type CHAR10

  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true
      mandt             = sy-mandt
      devid             = c_devid
      param1            = space
      param2            = space
      x_devid           = abap_true
      x_param1          = abap_true
      x_param2          = abap_true
      _scope            = '2'(t06)
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2
      OTHERS            = 3.
  IF sy-subrc IS INITIAL.
    CONCATENATE fp_lv_end_date+0(4) fp_lv_end_date+4(2) fp_lv_end_date+6(2) INTO lv_date.
    lst_interface-devid    = c_devid.
    lst_interface-lrdat    = lv_date.
    lst_interface-lrtime   = sy-uzeit.

    UPDATE zcainterface FROM lst_interface.

    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'
      EXPORTING
        mode_zcainterface = abap_true
        mandt             = sy-mandt
        devid             = c_devid
        param1            = space
        param2            = space
        x_devid           = abap_true
        x_param1          = abap_true
        x_param2          = abap_true
        _scope            = '3'(t07).
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  POPULATE_PATH
*&---------------------------------------------------------------------*
* To populate the path
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM populate_path CHANGING fp_p_path TYPE localfile.

  CONSTANTS: lc_devid  TYPE zdevid     VALUE 'I0342', " Development ID
             lc_i      TYPE tvarv_sign VALUE 'I',     " ABAP: ID: I/E (include/exclude values)
             lc_eq     TYPE tvarv_opti VALUE 'EQ',        " ABAP: Selection option (EQ/BT/CP/...)
             lc_param1 TYPE rvari_vnam VALUE 'APPL_SERV', " ABAP: Name of Variant Variable
             lc_param2 TYPE rvari_vnam VALUE 'FILENAME',  " ABAP: Name of Variant Variable
             lc_srno   TYPE tvarv_numb VALUE '01'.        " ABAP: Current selection number

  IF fp_p_path IS INITIAL.
    SELECT SINGLE low high " Lower and higher Value of Selection Condition
      FROM zcaconstant " Wiley Application Constant Table
      INTO (v_filepath, v_filenm)
      WHERE devid  = lc_devid
      AND param1   = lc_param1
      AND param2   = lc_param2
      AND srno     = lc_srno
      AND sign     = lc_i
      AND opti     = lc_eq
      AND activate = abap_true.

    fp_p_path  = v_filepath .

    IF sy-subrc IS NOT INITIAL.
      MESSAGE e000 WITH text-054.
      CLEAR: v_filepath, v_filenm.
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DATA
*&---------------------------------------------------------------------*
* Validation of selection screen values
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_data .

***Validation of billing document
  IF s_vbeln IS NOT INITIAL.

    SELECT SINGLE vbeln
              FROM vbuk
      INTO @DATA(lv_vbeln)
      WHERE vbeln IN @s_vbeln.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH text-049.   "Billing Document doesn't exist.
    ENDIF.                          "IF sy-subrc <> 0.
  ENDIF.                              "IF s_vbeln is NOT INITIAL.
***Validation of Billing type

  IF s_fkart IS NOT INITIAL.
    SELECT SINGLE fkart
      FROM tvfk
      INTO @DATA(lv_fkart)
      WHERE fkart IN @s_fkart.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH text-050.   "Billing type doesn't exist
    ENDIF.                          "IF sy-subrc <> 0.
  ENDIF.                                "IF s_FKART is NOT INITIAL.

***Validation of customer number

  IF s_kunnr IS NOT INITIAL.
    SELECT SINGLE kunnr
       FROM kna1
       INTO @DATA(lv_kunnr)
       WHERE kunnr IN @s_kunnr.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH text-051.    "Customer Number doesn't exist
    ENDIF.                           "IF sy-subrc <> 0.
  ENDIF.                               "IF s_kunnr is NOT INITIAL.

***Validation of material
  IF s_matnr IS NOT INITIAL.
    SELECT SINGLE matnr
      FROM mara
      INTO @DATA(lv_matnr)
      WHERE matnr IN @s_matnr.
    IF sy-subrc <> 0.
      MESSAGE e000 WITH text-052.    "Material Number doesn't exist
    ENDIF.                           "IF sy-subrc <> 0.
  ENDIF.                               "IF s_matnr is NOT INITIAL.

ENDFORM.
