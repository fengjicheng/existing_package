***INCLUDE RFKORI15PDF .

*-------Includes für syntax-check---------------------------------------
*NCLUDE RFKORI00.
*NCLUDE RFKORI80.
*NCLUDE RFKORI90.

*=======================================================================
*       Interne Perform-Routinen
*=======================================================================

*-----------------------------------------------------------------------
*       FORM AUSGABE_KONTOAUSZUG_PDF
*-----------------------------------------------------------------------
FORM ausgabe_kontoauszug_pdf.

  DATA:
    ls_header   TYPE rfkord_s_header,
    ls_address  TYPE rfkord_s_address,
    ls_item     TYPE rfkord_s_item,
    ls_sum      TYPE rfkord_s_sum,
    ls_rtab     TYPE rfkord_s_rtab,
    ls_item_alw TYPE rfkord_s_item_alw,

    lt_address  TYPE rfkord_t_address,
    lt_item     TYPE rfkord_t_item,
    lt_sum      TYPE rfkord_t_sum,
    lt_rtab     TYPE rfkord_t_rtab,
    lt_paymo    TYPE rfkord_t_paymo.

  DATA:
    ls_adrs       TYPE adrs,
    ls_adrs_print TYPE adrs_print,
    fp_docparams  TYPE sfpdocparams,
    ls_formoutput TYPE fpformoutput.                        "1636232

  IF xkausg IS INITIAL.
***<<<pdf-enabling
*    PERFORM form_start_as.
*   SAPScript logic for language determination can't be used
    language = save_langu.
***>>>pdf-enabling
    PERFORM find_sachbearbeiter.
    PERFORM read_t001s.
    save_usnam = hdusnam.
    PERFORM pruefen_husr03_2.
    IF xvorh2 IS INITIAL.
      PERFORM read_usr03_2.
      CLEAR husr03.
      MOVE-CORRESPONDING *usr03 TO husr03.                  "USR0340A
      APPEND husr03.
    ENDIF.
    countm = countm + 1.

    CLEAR rf140-avsid.
    IF NOT save_rxavis IS INITIAL.
      IF davsid IS INITIAL.
        IF save_koart = 'D'.
          save_konto = save_kunnr.
        ELSE.
          save_konto = save_lifnr.
        ENDIF.

        CLEAR   havico.
        REFRESH havico.

        LOOP AT hbsid.
          IF hbsid-augdt IS INITIAL
          OR hbsid-augdt GT datum02.
            MOVE-CORRESPONDING hbsid TO havico.
            havico-koart = 'D'.
* Process Currency Change
            IF NOT pcccheck IS INITIAL.
              MOVE-CORRESPONDING hbsid TO bsid.
              pcc_waers = bsid-waers.
              process   = save_repid.
              CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
                EXPORTING
                  iv_process  = process
                  iv_date     = datum02
                  iv_tabname  = 'BSID'
                  iv_fldname  = 'WRBTR'
                  is_line     = bsid
*                 IS_T001     =
                CHANGING
                  cv_amount   = bsid-wrbtr
                  cv_currency = bsid-waers.
              IF pcc_waers NE bsid-waers.
                havico-waers = bsid-waers.
                havico-wrbtr = bsid-wrbtr.
              ENDIF.
            ENDIF.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT dopos.
          IF dopos-augdt IS INITIAL
          OR dopos-augdt GT datum02.
            MOVE-CORRESPONDING dopos TO havico.
            havico-koart = 'D'.
* Process Currency Change
            IF NOT pcccheck IS INITIAL.
              MOVE-CORRESPONDING dopos TO bsid.
              pcc_waers = bsid-waers.
              process   = save_repid.
              CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
                EXPORTING
                  iv_process  = process
                  iv_date     = datum02
                  iv_tabname  = 'BSID'
                  iv_fldname  = 'WRBTR'
                  is_line     = bsid
*                 IS_T001     =
                CHANGING
                  cv_amount   = bsid-wrbtr
                  cv_currency = bsid-waers.
              IF pcc_waers NE bsid-waers.
                havico-waers = bsid-waers.
                havico-wrbtr = bsid-wrbtr.
              ENDIF.
            ENDIF.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT dmpos.
          IF dmpos-augdt IS INITIAL
          OR dmpos-augdt GT datum02.
            MOVE-CORRESPONDING dmpos TO havico.
            havico-koart = 'D'.
* Process Currency Change
            IF NOT pcccheck IS INITIAL.
              MOVE-CORRESPONDING dmpos TO bsid.
              pcc_waers = bsid-waers.
              process   = save_repid.
              CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
                EXPORTING
                  iv_process  = process
                  iv_date     = datum02
                  iv_tabname  = 'BSID'
                  iv_fldname  = 'WRBTR'
                  is_line     = bsid
*                 IS_T001     =
                CHANGING
                  cv_amount   = bsid-wrbtr
                  cv_currency = bsid-waers.
              IF pcc_waers NE bsid-waers.
                havico-waers = bsid-waers.
                havico-wrbtr = bsid-wrbtr.
              ENDIF.
            ENDIF.
            APPEND havico.
          ENDIF.
        ENDLOOP.

        LOOP AT hbsik.
          IF hbsik-augdt IS INITIAL
          OR hbsik-augdt GT datum02.
            MOVE-CORRESPONDING hbsik TO havico.
            havico-koart = 'K'.
* Process Currency Change
            IF NOT pcccheck IS INITIAL.
              MOVE-CORRESPONDING hbsik TO bsik.
              pcc_waers = bsik-waers.
              process   = save_repid.
              CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
                EXPORTING
                  iv_process  = process
                  iv_date     = datum02
                  iv_tabname  = 'BSIK'
                  iv_fldname  = 'WRBTR'
                  is_line     = bsik
*                 IS_T001     =
                CHANGING
                  cv_amount   = bsik-wrbtr
                  cv_currency = bsid-waers.
              IF pcc_waers NE bsik-waers.
                havico-waers = bsik-waers.
                havico-wrbtr = bsik-wrbtr.
              ENDIF.
            ENDIF.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT kopos.
          IF kopos-augdt IS INITIAL
          OR kopos-augdt GT datum02.
            MOVE-CORRESPONDING kopos TO havico.
            havico-koart = 'K'.
* Process Currency Change
            IF NOT pcccheck IS INITIAL.
              MOVE-CORRESPONDING kopos TO bsik.
              pcc_waers = bsik-waers.
              process   = save_repid.
              CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
                EXPORTING
                  iv_process  = process
                  iv_date     = datum02
                  iv_tabname  = 'BSIK'
                  iv_fldname  = 'WRBTR'
                  is_line     = bsik
*                 IS_T001     =
                CHANGING
                  cv_amount   = bsik-wrbtr
                  cv_currency = bsid-waers.
              IF pcc_waers NE bsik-waers.
                havico-waers = bsik-waers.
                havico-wrbtr = bsik-wrbtr.
              ENDIF.
            ENDIF.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT kmpos.
          IF kmpos-augdt IS INITIAL
          OR kmpos-augdt GT datum02.
            MOVE-CORRESPONDING kmpos TO havico.
            havico-koart = 'K'.
* Process Currency Change
            IF NOT pcccheck IS INITIAL.
              MOVE-CORRESPONDING kmpos TO bsik.
              pcc_waers = bsik-waers.
              process   = save_repid.
              CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
                EXPORTING
                  iv_process  = process
                  iv_date     = datum02
                  iv_tabname  = 'BSIK'
                  iv_fldname  = 'WRBTR'
                  is_line     = bsik
*                 IS_T001     =
                CHANGING
                  cv_amount   = bsik-wrbtr
                  cv_currency = bsid-waers.
              IF pcc_waers NE bsik-waers.
                havico-waers = bsik-waers.
                havico-wrbtr = bsik-wrbtr.
              ENDIF.
            ENDIF.
            APPEND havico.
          ENDIF.
        ENDLOOP.

        LOOP AT havico.
          IF havico-bukrs NE *t001-bukrs.
            SELECT SINGLE * FROM t001 INTO *t001
              WHERE bukrs = havico-bukrs.
          ENDIF.
          alw_waers = havico-waers.
          PERFORM currency_get_subsequent
                      USING
                         save_repid_alw
                         datum02
                         havico-bukrs
                      CHANGING
                         alw_waers.
          IF alw_waers NE havico-waers.
            PERFORM convert_foreign_to_foreign_cur
                        USING
                           datum02
                           havico-waers
                           *t001-waers
                           alw_waers
                        CHANGING
                           havico-wrbtr.
            havico-waers = alw_waers.
            MODIFY havico.
          ENDIF.
        ENDLOOP.

        CALL FUNCTION 'REMADV_CORRESPONDENCE_INSERT'
          EXPORTING
            i_vorid = '0001'   "Kontoauszug
            i_bukrs = save_bukrs
            i_koart = save_koart
            i_konto = save_konto
          IMPORTING
            e_avsid = rf140-avsid
          TABLES
            t_avico = havico
          EXCEPTIONS
            error   = 1
            OTHERS  = 0.

        IF sy-subrc = 0.
          CALL FUNCTION 'REMADV_SAVE_DB_ALL'
            EXPORTING
              i_dialog_update = 'X'
              i_commit        = ' '
            EXCEPTIONS
              OTHERS          = 1.
        ELSE.
          CLEAR fimsg.
          fimsg-msgid = 'FB'.
          fimsg-msgty = 'S'.
          fimsg-msgno = '862'.
          fimsg-msgv1 = save_bukrs.
          fimsg-msgv2 = save_koart.
          fimsg-msgv3 = save_konto.
          fimsg-msgv4 = '08'.
          PERFORM message_collect.
        ENDIF.

      ELSE.
        IF save_koart = 'D'.
          save_konto = save_kunnr.
        ELSE.
          save_konto = save_lifnr.
        ENDIF.

        CLEAR   havico.
        REFRESH havico.

        LOOP AT hbsid.
          IF hbsid-augdt IS INITIAL
          OR hbsid-augdt GT datum02.
            MOVE-CORRESPONDING hbsid TO havico.
            havico-koart = 'D'.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT dopos.
          IF dopos-augdt IS INITIAL
          OR dopos-augdt GT datum02.
            MOVE-CORRESPONDING dopos TO havico.
            havico-koart = 'D'.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT dmpos.
          IF dmpos-augdt IS INITIAL
          OR dmpos-augdt GT datum02.
            MOVE-CORRESPONDING dmpos TO havico.
            havico-koart = 'D'.
            APPEND havico.
          ENDIF.
        ENDLOOP.

        LOOP AT hbsik.
          IF hbsik-augdt IS INITIAL
          OR hbsik-augdt GT datum02.
            MOVE-CORRESPONDING hbsik TO havico.
            havico-koart = 'K'.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT kopos.
          IF kopos-augdt IS INITIAL
          OR kopos-augdt GT datum02.
            MOVE-CORRESPONDING kopos TO havico.
            havico-koart = 'K'.
            APPEND havico.
          ENDIF.
        ENDLOOP.
        LOOP AT kmpos.
          IF kmpos-augdt IS INITIAL
          OR kmpos-augdt GT datum02.
            MOVE-CORRESPONDING kmpos TO havico.
            havico-koart = 'K'.
            APPEND havico.
          ENDIF.
        ENDLOOP.

        CLEAR   avik.
        CLEAR   havip.
        REFRESH havip.

        avik-bukrs = save_bukrs.
        avik-koart = save_koart.
        avik-konto = save_konto.
        avik-avsid = davsid.

        CALL FUNCTION 'REMADV_POSITIONS_READ'
          EXPORTING
            i_avik        = avik
          TABLES
            t_avip        = havip
          EXCEPTIONS
            nothing_found = 1
            OTHERS        = 2.

        LOOP AT havico.
          LOOP AT havip
            WHERE belnr = havico-belnr
            AND   gjahr = havico-gjahr
            AND   buzei = havico-buzei.
            DELETE havip.
            EXIT.
          ENDLOOP.
          IF sy-subrc = 0.
            DELETE havico.
          ENDIF.
        ENDLOOP.

        DESCRIBE TABLE havico LINES av1lines.
        DESCRIBE TABLE havip  LINES av2lines.
        IF av1lines NE 0
        OR av1lines NE 0.
          CLEAR rf140-avsid.

          CLEAR hbkormkey.
          CLEAR herdata.
          hbkormkey-bukrs = hdbukrs.
          hbkormkey-koart = hdkoart.
          hbkormkey-konto = hdkonto.
          hbkormkey-belnr = dabelnr.
          hbkormkey-gjahr = dagjahr.
          CONDENSE hbkormkey.
          herdata-usnam = hdusnam.
          herdata-datum = hddatum.
          herdata-uzeit = hduzeit.
          CLEAR fimsg.
          fimsg-msort = '    '. fimsg-msgid = 'FB'. fimsg-msgty = 'S'.
          fimsg-msgno = '863'.
          fimsg-msgv1 = davsid.
          fimsg-msgv2 = bkorm-event.
          fimsg-msgv3 = hbkormkey.
          fimsg-msgv4 = herdata.
          PERFORM message_collect.

        ELSE.
          rf140-avsid = davsid.
        ENDIF.
      ENDIF.
    ENDIF.


    IF NOT save_rzlsch IS INITIAL.
      CLEAR paymi.
      CLEAR xkausgzt.
      CALL FUNCTION 'PAYMENT_MEDIUM_INIT'
        IMPORTING
          e_paymo = paymo
        EXCEPTIONS
          OTHERS  = 0.
    ENDIF.


    CLEAR ls_header.
    CLEAR ls_address.
    REFRESH lt_address[].
    CLEAR ls_item.
    REFRESH lt_item[].
    CLEAR ls_sum.
    REFRESH lt_sum[].
    CLEAR ls_rtab.
    REFRESH lt_rtab[].

*-------------------------------header,address------------------------*
    MOVE-CORRESPONDING dkadr TO ls_adrs.
    IF NOT dkadr-adrnr IS INITIAL.
      CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
        EXPORTING
          address_type      = '1'
          address_number    = dkadr-adrnr
          sender_country    = dkadr-inlnd
*         PERSON_NUMBER     = ' '
        IMPORTING
          address_printform = ls_adrs_print
*         NUMBER_OF_USED_LINES                 =
        EXCEPTIONS
          OTHERS            = 1.
* fill receiver address information into header
      MOVE-CORRESPONDING ls_adrs_print TO ls_header.
* also provide address information in address
      MOVE-CORRESPONDING ls_adrs_print TO ls_address.
    ELSE.
      MOVE-CORRESPONDING dkadr TO ls_adrs.
      CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
        EXPORTING
          adrswa_in  = ls_adrs
        IMPORTING
          adrswa_out = ls_adrs
*         NUMBER_OF_USED_LINES                 =
        EXCEPTIONS
          OTHERS     = 1.
* fill receiver address information into header
      MOVE-CORRESPONDING ls_adrs TO ls_header.
* also provide address information in address
      MOVE-CORRESPONDING ls_adrs TO ls_address.
    ENDIF.

* header
    MOVE-CORRESPONDING fsabe TO ls_header.
    MOVE-CORRESPONDING bkorm TO ls_header.
    MOVE-CORRESPONDING t001s TO ls_header.
    MOVE t001-bukrs TO ls_header-bukrs.                     "2025928
    MOVE dkadr-adrnr TO ls_header-adrnr.
    MOVE dkadr-konto TO ls_header-konto.
    MOVE dkadr-land1 TO ls_header-land1.
    MOVE dkadr-zsabe TO ls_header-zsabe.
    MOVE dkadr-eikto TO ls_header-eikto.
    MOVE t001-adrnr TO ls_header-sadrnr.
    MOVE t001-waers TO ls_header-hwaer.
    MOVE dkadr-inlnd TO ls_header-inlnd.

* enrich address-structure with masterdata
    ls_address-corrid = co_rfkord_rec.   "receiveraddress
    MOVE dkadr-adrnr TO ls_address-adrnr.
    MOVE dkadr-konto TO ls_address-konto.
    MOVE dkadr-land1 TO ls_address-land1.
    MOVE dkadr-zsabe TO ls_address-zsabe.
    MOVE dkadr-eikto TO ls_address-eikto.
    MOVE-CORRESPONDING fsabe TO ls_address.

    CASE save_koart.
      WHEN 'D'.
        MOVE-CORRESPONDING kna1 TO ls_address.
        MOVE-CORRESPONDING knb1 TO ls_address.
      WHEN 'K'.
        MOVE-CORRESPONDING lfa1 TO ls_address.
        MOVE-CORRESPONDING lfb1 TO ls_address.
    ENDCASE.


* standardtexts (HEADER; FOOTER etc.)
    MOVE t001g-txtko  TO ls_header-txtko.
    MOVE t001g-txtfu  TO ls_header-txtfu.
    MOVE t001g-txtun  TO ls_header-txtun.
    MOVE t001g-txtab  TO ls_header-txtab.
    MOVE t001g-header TO ls_header-header.
    MOVE t001g-footer TO ls_header-footer.
    MOVE t001g-sender TO ls_header-sender.
    MOVE t001g-greetings TO ls_header-greetings.
    MOVE t001g-logo   TO ls_header-logo.
    MOVE t001g-graph  TO ls_header-graph.

    IF save_rxopol IS INITIAL.
*=> ID (account statement)
      ls_header-corrid = co_rfkord_ast. "account statement
    ELSE.
*=> ID (open item list)
      ls_header-corrid = co_rfkord_oil. "open item list
    ENDIF.

* language
    CLEAR ls_header-spras.
    ls_header-spras = language.

* Dates (from-, to- and key-date)
    ls_header-date_from = rf140-datu1.
    ls_header-date_to = rf140-datu2.
    ls_header-key_date = rf140-stida.
    ls_header-vstid = rf140-vstid.

* individual text
    ls_header-tdname = rf140-tdname.
    ls_header-tdspras = rf140-tdspras.

    APPEND ls_address TO lt_address.

*-------------------------------header completed-----------------------*

    CLEAR   saldoa.
    REFRESH saldoa.
    CLEAR   saldoe.
    REFRESH saldoe.
    CLEAR   saldof.
    REFRESH saldof.
    CLEAR   saldom.
    REFRESH saldom.
    CLEAR   saldok.
    REFRESH saldok.

    IF save_koart = 'D'.

      LOOP AT dopos.
        IF dopos-bukrs NE *t001-bukrs.
          SELECT SINGLE * FROM t001 INTO *t001
            WHERE bukrs = dopos-bukrs.
        ENDIF.
        CLEAR ls_item-netdt.
        IF NOT save_rxekvb IS INITIAL.
          IF NOT xpkont IS INITIAL.
            AT NEW <konto1>.
              CLEAR   saldok.
              REFRESH saldok.
            ENDAT.
          ENDIF.
        ENDIF.
        IF NOT xumskz IS INITIAL.
          AT NEW <umskz1>.
            IF NOT rxopos IS INITIAL
            OR NOT save_rxopol IS INITIAL.
              save_umskz = <umskz1>.
              IF NOT <umskz1>    IS INITIAL.
                PERFORM read_t074t.
              ENDIF.
              CLEAR   saldoz.
              REFRESH saldoz.
            ENDIF.
          ENDAT.
        ENDIF.
        MOVE-CORRESPONDING dopos TO bsid.
        MOVE-CORRESPONDING bsid TO ls_item.
        MOVE bsid-kunnr TO ls_item-konto.
        MOVE save_koart TO ls_item-koart.

        PERFORM fill_waehrungsfelder_bsidk.
        ls_item-wrshb = rf140-wrshb.
        ls_item-dmshb = rf140-dmshb.
        ls_item-wsshb = rf140-wsshb.
        ls_item-skshb = rf140-skshb.
        ls_item-wsshv = rf140-wsshv.
        ls_item-skshv = rf140-skshv.

        PERFORM fill_skonto_bsidk.
        ls_item-wskta = rf140-wskta.
        ls_item-wrshn = rf140-wrshn.

        CLEAR ls_item-waers.
        ls_item-waers = bsid-waers.
*        IF BSID-BSTAT NE 'S'.
        IF bsid-shkzg = 'S'.
          ls_item-psshb = dopos-pswbt.
          ls_item-zlshb = dopos-nebtr.
        ELSE.
          ls_item-psshb = 0 - dopos-pswbt.
          ls_item-zlshb = 0 - dopos-nebtr.
        ENDIF.

*** expiring currencies: store old amounts
        ls_item_alw-waers_alw = ls_item-waers.
        ls_item_alw-pswsl_alw = ls_item-pswsl.
        ls_item_alw-wrshb_alw = ls_item-wrshb.
        ls_item_alw-dmshb_alw = ls_item-dmshb.
        ls_item_alw-wsshb_alw = ls_item-wsshb.
        ls_item_alw-skshb_alw = ls_item-skshb.
        ls_item_alw-wsshv_alw = ls_item-wsshv.
        ls_item_alw-skshv_alw = ls_item-skshv.
        ls_item_alw-wrshn_alw = ls_item-wrshn.
*        ls_item_alw-wrshn_alw = ls_item-wrshn.
        ls_item_alw-psshb_alw = ls_item-psshb.
        MOVE *t001-waers TO ls_item_alw-hwaer_alw.

* provide old amounts in item structure (via ci-include)
        MOVE-CORRESPONDING ls_item_alw TO ls_item.

        alw_waers = bsid-waers.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsid-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE bsid-waers.
          bsid-waers = alw_waers.
          PERFORM curr_document_convert_bsid
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsid-waers
                      CHANGING
                         bsid.

          PERFORM fill_waehrungsfelder_bsidk.
          ls_item-wrshb = rf140-wrshb.
          ls_item-dmshb = rf140-dmshb.
          ls_item-wsshb = rf140-wsshb.
          ls_item-skshb = rf140-skshb.
          ls_item-wsshv = rf140-wsshv.
          ls_item-skshv = rf140-skshv.

          PERFORM fill_skonto_bsidk.
          ls_item-wskta = rf140-wskta.
          ls_item-wrshn = rf140-wrshn.

          CLEAR ls_item-waers.
          ls_item-waers = bsid-waers.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsid-waers
                      CHANGING
                         dopos-nebtr.
          IF bsid-shkzg = 'S'.
            ls_item-zlshb = dopos-nebtr.
          ELSE.
            ls_item-zlshb = 0 - dopos-nebtr.
          ENDIF.
        ENDIF.
*           IF  BSID-AUGDT IS INITIAL
*           OR  BSID-AUGDT GT SAVE2_DATUM.
        alw_waers = dopos-pswsl.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsid-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE dopos-pswsl.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         dopos-pswsl
                         ls_item_alw-hwaer_alw
                         alw_waers
                      CHANGING
                         dopos-pswbt.
          dopos-pswsl = alw_waers.
          bsid-pswsl  = alw_waers.
          bsid-pswbt  = dopos-pswbt.
          IF bsid-shkzg = 'S'.
            ls_item-psshb = dopos-pswbt.
          ELSE.
            ls_item-psshb = 0 - dopos-pswbt.
          ENDIF.
        ENDIF.
*           endif.
*         endif.

* Process Currency Change
        IF NOT pcccheck IS INITIAL.
*          process   = save_repid.
          process   = save_repid_alw.
          CLEAR save3_datum.
          CLEAR pcc_nocheck.
*          If SAVE_RXOPOL is initial.
*            save3_datum = datum01.
*          else.
          save3_datum = datum02.
*          endif.

          MOVE-CORRESPONDING dopos TO bkpf.  "*BSID
          MOVE-CORRESPONDING dopos TO bseg.  "*BSID + NEBTR
          bseg-koart = 'D'.
          *bkpf = bkpf.
          *bseg = bseg.
          pcc_waers = bkpf-waers.

          CALL FUNCTION 'FI_ITEMS_PROC_CURR_CHANGE'
            EXPORTING
              iv_process  = process
*             IV_DATE     = datum02
              iv_date     = save3_datum
              iv_tabname  = 'BSEG'
*             IS_KNA1     =
*             IS_LFA1     =
*             IS_BSEC     =
              is_bkpf     = bkpf
*             IS_T001     =
*             IV_NOCHECK  =
*           TABLES
*             IT_FIELDLIST              =
            CHANGING
              cs_line     = bseg
              cv_currency = bkpf-waers
            EXCEPTIONS
*             FIELD_NOT_AMOUNT          = 1
*             CURRENCY_MISSING          = 2
*             ERROR_IN_CONVERSION       = 3
              OTHERS      = 4.

          IF sy-subrc <> 0.
*           Implement suitable error handling here
          ELSE.
            IF pcc_waers NE bkpf-waers.
              MOVE-CORRESPONDING bkpf TO bsid.
              MOVE-CORRESPONDING bseg TO bsid.
              PERFORM fill_waehrungsfelder_bsidk.
              ls_item-wrshb = rf140-wrshb.
              ls_item-dmshb = rf140-dmshb.
              ls_item-wsshb = rf140-wsshb.
              ls_item-skshb = rf140-skshb.
              ls_item-wsshv = rf140-wsshv.
              ls_item-skshv = rf140-skshv.
              PERFORM fill_skonto_bsidk.
              ls_item-wskta = rf140-wskta.
              ls_item-wrshn = rf140-wrshn.
*              CLEAR RF140-WAERS.
*              RF140-WAERS = BSID-WAERS.
              CLEAR ls_item-waers.
              ls_item-waers = bsid-waers.
              dopos-nebtr = bseg-nebtr.
              IF bsid-shkzg = 'S'.
                ls_item-zlshb = dopos-nebtr.
              ELSE.
                ls_item-zlshb = 0 - dopos-nebtr.
              ENDIF.
            ENDIF.
            IF save_rxopol IS INITIAL.
              pcc_nocheck = abap_true.
            ENDIF.
          ENDIF.

          pcc_waers = dopos-pswsl.
          bkpf = *bkpf.
          bseg = *bseg.
          CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
            EXPORTING
              iv_process  = process
*             IV_DATE     = datum02
              iv_date     = save3_datum
              iv_tabname  = 'BSEG'
              iv_fldname  = 'PSWBT'
              is_line     = bseg
              is_bkpf     = bkpf
*             IS_T001     =
              iv_nocheck  = pcc_nocheck
            CHANGING
              cv_amount   = bseg-pswbt
              cv_currency = bseg-pswsl.

          dopos-pswsl = bseg-pswsl.
          dopos-pswbt = bseg-pswbt.
          IF pcc_waers NE dopos-pswsl.
            bsid-pswsl  = dopos-pswsl.
            bsid-pswbt  = dopos-pswbt.
            IF bsid-shkzg = 'S'.
              ls_item-psshb = dopos-pswbt.
            ELSE.
              ls_item-psshb = 0 - dopos-pswbt.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR saldoa.
        MOVE dopos-pswsl  TO saldoa-waers.
        MOVE ls_item-dmshb  TO saldoa-saldoh.
        MOVE ls_item-psshb  TO saldoa-saldow.
        IF ( bsid-augdt IS INITIAL
        OR   bsid-augdt GT save2_datum )
        AND NOT save_rxopol IS INITIAL.
          MOVE ls_item-wskta  TO saldoa-salsk.
          MOVE ls_item-wrshn  TO saldoa-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoa-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoa-saldoo.
        ENDIF.
        COLLECT saldoa.
*        CLEAR saldoe.
*        MOVE dopos-pswsl  TO saldoe-waers.
*        MOVE ls_item-dmshb  TO saldoe-saldoh.
*        MOVE ls_item-psshb  TO saldoe-saldow.
*        IF  bsid-augdt IS INITIAL
*        OR  bsid-augdt GT save2_datum.
*          MOVE ls_item-wskta  TO saldoe-salsk.
*          MOVE ls_item-wrshn  TO saldoe-saldn.
*        ENDIF.
*        COLLECT saldoe.
        CLEAR saldoz.
        MOVE dopos-pswsl  TO saldoz-waers.
        MOVE ls_item-dmshb  TO saldoz-saldoh.
        MOVE ls_item-psshb  TO saldoz-saldow.
        IF  bsid-augdt IS INITIAL
        OR  bsid-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoz-salsk.
          MOVE ls_item-wrshn  TO saldoz-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoz-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoz-saldoo.
        ENDIF.
        COLLECT saldoz.
        CLEAR saldok.
        MOVE dopos-kunnr  TO saldok-konto.
        MOVE dopos-pswsl  TO saldok-waers.
        MOVE ls_item-dmshb  TO saldok-saldoh.
        MOVE ls_item-psshb  TO saldok-saldow.
        IF dopos-shkzg = 'S'.
          MOVE ls_item-psshb  TO saldok-saldop.
          CLEAR saldok-saldon.
        ELSE.
          CLEAR saldok-saldop.
          MOVE ls_item-psshb  TO saldok-saldon.
        ENDIF.
        MOVE ls_item-zlshb  TO saldok-nebtr.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldok-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldok-saldoo.
        ENDIF.
        COLLECT saldok.
*        ENDIF.
        IF NOT rf140-vstid IS INITIAL. "kommt über selection-screen
          ls_item-vstid = rf140-vstid.
          IF dopos-vztas IS INITIAL.
            CLEAR ls_item-vztas.
            ls_item-netdt = dopos-netdt.
          ELSE.
            ls_item-vztas = dopos-vztas.
            ls_item-netdt = dopos-netdt.
          ENDIF.
          IF dopos-augbl IS INITIAL
          OR ( dopos-augdt GT rf140-vstid
               AND NOT rvztag IS INITIAL ).
            IF ls_item-vztas GE '0'.
              CLEAR saldof.
              MOVE dopos-pswsl  TO saldof-waers.
              MOVE ls_item-dmshb  TO saldof-saldoh.
              MOVE ls_item-psshb  TO saldof-saldow.
              MOVE ls_item-wskta  TO saldof-salsk.
              MOVE ls_item-wrshn  TO saldof-saldn.
              COLLECT saldof.
            ENDIF.
          ENDIF.
        ENDIF.

        IF NOT pcccheck IS INITIAL
*       and save3_datum ne datum02.
        AND NOT pcc_nocheck IS INITIAL.
          pcc_waers = dopos-pswsl.
          bkpf = *bkpf.
          bseg = *bseg.
          CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
            EXPORTING
              iv_process  = process
              iv_date     = datum02
*             IV_DATE     = datum01
              iv_tabname  = 'BSEG'
              iv_fldname  = 'PSWBT'
              is_line     = bseg
              is_bkpf     = bkpf
*             IS_T001     =
            CHANGING
              cv_amount   = bseg-pswbt
              cv_currency = bseg-pswsl.

          dopos-pswsl = bseg-pswsl.
          dopos-pswbt = bseg-pswbt.
          IF pcc_waers NE dopos-pswsl.
            bsid-pswsl  = dopos-pswsl.
            bsid-pswbt  = dopos-pswbt.
            IF bsid-shkzg = 'S'.
              ls_item-psshb = dopos-pswbt.
            ELSE.
              ls_item-psshb = 0 - dopos-pswbt.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR saldoe.
        MOVE dopos-pswsl  TO saldoe-waers.
        MOVE ls_item-dmshb  TO saldoe-saldoh.
        MOVE ls_item-psshb  TO saldoe-saldow.
        IF  bsid-augdt IS INITIAL
        OR  bsid-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoe-salsk.
          MOVE ls_item-wrshn  TO saldoe-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoe-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoe-saldoo.
        ENDIF.
        COLLECT saldoe.

        IF bsid-sgtxt(1) NE '*'.
          ls_item-sgtxt = space.
        ELSE.
          ls_item-sgtxt = bsid-sgtxt+1.
        ENDIF.
        IF bsid-xblnr IS INITIAL.
          MOVE bsid-belnr TO ls_item-belegnum.
        ELSE.
          MOVE bsid-xblnr TO ls_item-belegnum.
        ENDIF.

        CLEAR save_blart.
        save_blart = bsid-blart.
        PERFORM read_t003t.
        save_bschl = bsid-bschl.
        PERFORM read_tbslt.
        IF NOT rxopos IS INITIAL
        OR NOT save_rxopol IS INITIAL.
          IF  ( save_rxekvb NE space
          AND   rxekep = '1'
          AND   bsid-kunnr NE save_kunnr )
          OR  ( save_rxekvb NE space
          AND   rxekep = '2' ).
          ELSE.
            ls_item-corrid = co_rfkord_oil. "offene-Posten-Liste
            ls_item-blart_desc = t003t-ltext.
            ls_item-bschl_desc = tbslt-ltext.
            APPEND ls_item TO lt_item.
*------------------------------item completed--------------------------*
          ENDIF.
        ENDIF.
        IF NOT xumskz IS INITIAL.
          AT END OF <umskz1>.
            IF NOT rxopos IS INITIAL
            OR NOT save_rxopol IS INITIAL.
              LOOP AT saldoz.
                CLEAR ls_sum.
                ls_sum-sum_id = co_rfkord_sdzo.
                ls_sum-genid_name = 'UMSKZ'.
                ls_sum-genid_value = <umskz1>.
                ls_sum-genid_text = t074t-ltext.
                MOVE saldoz-waers  TO ls_sum-waers.
                MOVE saldoz-saldow TO ls_sum-saldow.
                MOVE t001-waers    TO ls_sum-hwaer.
                MOVE saldoz-saldoh TO ls_sum-saldoh.
                MOVE saldoz-salsk  TO ls_sum-salsk.
                MOVE saldoz-saldn  TO ls_sum-saldn.
                MOVE saldoz-waerso TO ls_sum-waerso.
                MOVE saldoz-saldoo TO ls_sum-saldoo.
                APPEND ls_sum TO lt_sum.
              ENDLOOP.
            ENDIF.
          ENDAT.
        ENDIF.
        IF NOT save_rxekvb IS INITIAL.
          IF NOT xpkont IS INITIAL.
            AT END OF <konto1>.
              IF  rxekep IS INITIAL
              AND rxeksu IS INITIAL.
              ELSE.
                IF NOT rxopos IS INITIAL
                OR NOT save_rxopol IS INITIAL.
                  SORT saldok BY waers.
                  LOOP AT saldok.
*              IF  ( RXEKEP = '1'
*              AND SALDOK-KONTO =  SAVE_KUNNR
*              AND     RXEKSU IS INITIAL ).
*              ELSE.
                    CLEAR ls_sum.
                    ls_sum-sum_id = co_rfkord_sdko.
                    MOVE saldok-konto  TO ls_sum-konto.
                    MOVE saldok-waers  TO ls_sum-waers.
                    MOVE saldok-saldow TO ls_sum-saldow.
                    MOVE t001-waers    TO ls_sum-hwaer.
                    MOVE saldok-saldoh TO ls_sum-saldoh.
                    MOVE saldok-saldop TO ls_sum-saldop.
                    MOVE saldok-saldon TO ls_sum-saldon.
                    MOVE saldok-nebtr  TO ls_sum-nebtr.
                    MOVE saldok-waerso TO ls_sum-waerso.
                    MOVE saldok-saldoo TO ls_sum-saldoo.
                    APPEND ls_sum TO lt_sum.
*              ENDIF.
                  ENDLOOP.
                ENDIF.
              ENDIF.
            ENDAT.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ELSE.
      LOOP AT kopos.

        IF *t001-bukrs NE kopos-bukrs.
          SELECT SINGLE * FROM t001 INTO *t001
            WHERE bukrs = kopos-bukrs.
        ENDIF.
        CLEAR ls_item-netdt.
        IF NOT xumskz IS INITIAL.
          AT NEW <umskz2>.
            IF NOT rxopos IS INITIAL
            OR NOT save_rxopol IS INITIAL.
              save_umskz = <umskz2>.
              IF NOT <umskz2>    IS INITIAL.
                PERFORM read_t074t.
              ENDIF.
              CLEAR   saldoz.
              REFRESH saldoz.
            ENDIF.
          ENDAT.
        ENDIF.

        MOVE-CORRESPONDING kopos TO bsik.
        MOVE-CORRESPONDING bsik TO ls_item.
        MOVE bsik-lifnr TO ls_item-konto.
        MOVE save_koart TO ls_item-koart.

        PERFORM fill_waehrungsfelder_bsidk.
        ls_item-wrshb = rf140-wrshb.
        ls_item-dmshb = rf140-dmshb.
        ls_item-wsshb = rf140-wsshb.
        ls_item-skshb = rf140-skshb.
        ls_item-wsshv = rf140-wsshv.
        ls_item-skshv = rf140-skshv.

        PERFORM fill_skonto_bsidk.
        ls_item-wskta = rf140-wskta.
        ls_item-wrshn = rf140-wrshn.

        CLEAR ls_item-waers.
        ls_item-waers = bsik-waers.
*        IF BSIK-BSTAT NE 'S'.
        IF bsik-shkzg = 'S'.
          ls_item-psshb = kopos-pswbt.
          ls_item-zlshb = kopos-nebtr.
        ELSE.
          ls_item-psshb = 0 - kopos-pswbt.
          ls_item-zlshb = 0 - kopos-nebtr.
        ENDIF.

*** expiring currencies: store old amounts
        ls_item_alw-waers_alw = ls_item-waers.
        ls_item_alw-pswsl_alw = ls_item-pswsl.
        ls_item_alw-wrshb_alw = ls_item-wrshb.
        ls_item_alw-dmshb_alw = ls_item-dmshb.
        ls_item_alw-wsshb_alw = ls_item-wsshb.
        ls_item_alw-skshb_alw = ls_item-skshb.
        ls_item_alw-wsshv_alw = ls_item-wsshv.
        ls_item_alw-skshv_alw = ls_item-skshv.
        ls_item_alw-wrshn_alw = ls_item-wrshn.
        ls_item_alw-psshb_alw = ls_item-psshb.
        MOVE *t001-waers TO ls_item_alw-hwaer_alw.

* provide old amounts in item structure (via ci-include)
        MOVE-CORRESPONDING ls_item_alw TO ls_item.

        alw_waers = bsik-waers.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsik-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE bsik-waers.
          bsik-waers = alw_waers.
          PERFORM curr_document_convert_bsik
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsik-waers
                      CHANGING
                         bsik.
          PERFORM fill_waehrungsfelder_bsidk.
          ls_item-wrshb = rf140-wrshb.
          ls_item-dmshb = rf140-dmshb.
          ls_item-wsshb = rf140-wsshb.
          ls_item-skshb = rf140-skshb.
          ls_item-wsshv = rf140-wsshv.
          ls_item-skshv = rf140-skshv.

          PERFORM fill_skonto_bsidk.
          ls_item-wskta = rf140-wskta.
          ls_item-wrshn = rf140-wrshn.

          CLEAR ls_item-waers.
          ls_item-waers = bsik-waers.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsik-waers
                      CHANGING
                         kopos-nebtr.
          IF bsik-shkzg = 'S'.
            ls_item-zlshb = kopos-nebtr.
          ELSE.
            ls_item-zlshb = 0 - kopos-nebtr.
          ENDIF.
        ENDIF.
*           IF  BSIk-AUGDT IS INITIAL
*           OR  BSIk-AUGDT GT SAVE2_DATUM.
        alw_waers = kopos-pswsl.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsik-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE kopos-pswsl.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         kopos-pswsl
                         ls_item_alw-hwaer_alw
                         alw_waers
                      CHANGING
                         kopos-pswbt.
          kopos-pswsl = alw_waers.
          bsik-pswsl  = alw_waers.
          bsik-pswbt  = kopos-pswbt.
          IF bsik-shkzg = 'S'.
            ls_item-psshb = kopos-pswbt.
          ELSE.
            ls_item-psshb = 0 - kopos-pswbt.
          ENDIF.
*           endif.
        ENDIF.
*         endif.

* Process Currency Change
        IF NOT pcccheck IS INITIAL.
*          process   = save_repid.
          process   = save_repid_alw.
          CLEAR pcc_nocheck.
          CLEAR save3_datum.
*          If SAVE_RXOPOL is initial.
*            save3_datum = datum01.
*          else.
          save3_datum = datum02.
*          endif.

          MOVE-CORRESPONDING kopos TO bkpf.  "*BSIk
          MOVE-CORRESPONDING kopos TO bseg.  "*BSIk + NEBTR
          bseg-koart = 'K'.
          *bkpf = bkpf.
          *bseg = bseg.
          pcc_waers = bkpf-waers.

          CALL FUNCTION 'FI_ITEMS_PROC_CURR_CHANGE'
            EXPORTING
              iv_process  = process
*             IV_DATE     = datum02
              iv_date     = save3_datum
              iv_tabname  = 'BSEG'
*             IS_KNA1     =
*             IS_LFA1     =
*             IS_BSEC     =
              is_bkpf     = bkpf
*             IS_T001     =
*             IV_NOCHECK  =
*           TABLES
*             IT_FIELDLIST              =
            CHANGING
              cs_line     = bseg
              cv_currency = bkpf-waers
            EXCEPTIONS
*             FIELD_NOT_AMOUNT          = 1
*             CURRENCY_MISSING          = 2
*             ERROR_IN_CONVERSION       = 3
              OTHERS      = 4.

          IF sy-subrc <> 0.
*           Implement suitable error handling here
          ELSE.
            IF pcc_waers NE bkpf-waers.
              MOVE-CORRESPONDING bkpf TO bsik.
              MOVE-CORRESPONDING bseg TO bsik.
              PERFORM fill_waehrungsfelder_bsidk.
              ls_item-wrshb = rf140-wrshb.
              ls_item-dmshb = rf140-dmshb.
              ls_item-wsshb = rf140-wsshb.
              ls_item-skshb = rf140-skshb.
              ls_item-wsshv = rf140-wsshv.
              ls_item-skshv = rf140-skshv.
              PERFORM fill_skonto_bsidk.
              ls_item-wskta = rf140-wskta.
              ls_item-wrshn = rf140-wrshn.
*              CLEAR RF140-WAERS.
*              RF140-WAERS = BSID-WAERS.
              CLEAR ls_item-waers.
              ls_item-waers = bsik-waers.

              dopos-nebtr = bseg-nebtr.
              IF bsik-shkzg = 'S'.
                ls_item-zlshb = kopos-nebtr.
              ELSE.
                ls_item-zlshb = 0 - kopos-nebtr.
              ENDIF.
              IF save_rxopol IS INITIAL.
                pcc_nocheck = abap_true.
              ENDIF.
            ENDIF.
          ENDIF.

          pcc_waers = kopos-pswsl.
          bkpf = *bkpf.
          bseg = *bseg.
          CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
            EXPORTING
              iv_process  = process
*             IV_DATE     = datum02
              iv_date     = save3_datum
              iv_tabname  = 'BSEG'
              iv_fldname  = 'PSWBT'
              is_line     = bseg
              is_bkpf     = bkpf
*             IS_T001     =
              iv_nocheck  = pcc_nocheck
            CHANGING
              cv_amount   = bseg-pswbt
              cv_currency = bseg-pswsl.

          kopos-pswsl = bseg-pswsl.
          kopos-pswbt = bseg-pswbt.
          IF pcc_waers NE kopos-pswsl.
            bsik-pswsl  = kopos-pswsl.
            bsik-pswbt  = kopos-pswbt.
            IF bsik-shkzg = 'S'.
              ls_item-psshb = kopos-pswbt.
            ELSE.
              ls_item-psshb = 0 - kopos-pswbt.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR saldoa.
        MOVE kopos-pswsl  TO saldoa-waers.
        MOVE ls_item-dmshb  TO saldoa-saldoh.
        MOVE ls_item-psshb  TO saldoa-saldow.
        IF ( bsik-augdt IS INITIAL
        OR   bsik-augdt GT save2_datum )
        AND NOT save_rxopol IS INITIAL.
          MOVE ls_item-wskta  TO saldoa-salsk.
          MOVE ls_item-wrshn  TO saldoa-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoa-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoa-saldoo.
        ENDIF.
        COLLECT saldoa.
*        CLEAR saldoe.
*        MOVE kopos-pswsl  TO saldoe-waers.
*        MOVE ls_item-dmshb  TO saldoe-saldoh.
*        MOVE ls_item-psshb  TO saldoe-saldow.
*        IF bsik-augdt IS INITIAL
*        OR bsik-augdt GT save2_datum.
*          MOVE ls_item-wskta  TO saldoe-salsk.
*          MOVE ls_item-wrshn  TO saldoe-saldn.
*        ENDIF.
*        COLLECT saldoe.
        CLEAR saldoz.
        MOVE kopos-pswsl  TO saldoz-waers.
        MOVE ls_item-dmshb  TO saldoz-saldoh.
        MOVE ls_item-psshb  TO saldoz-saldow.
        IF  bsik-augdt IS INITIAL
        OR  bsik-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoz-salsk.
          MOVE ls_item-wrshn  TO saldoz-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoz-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoz-saldoo.
        ENDIF.
        COLLECT saldoz.
*        ENDIF.
        IF NOT rf140-vstid IS INITIAL.
          ls_item-vstid = rf140-vstid.
          IF kopos-vztas IS INITIAL.
            CLEAR ls_item-vztas.
            ls_item-netdt = kopos-netdt.
          ELSE.
            ls_item-vztas = kopos-vztas.
            ls_item-netdt = kopos-netdt.
          ENDIF.
          IF kopos-augbl IS INITIAL
          OR ( kopos-augdt GT rf140-vstid
              AND NOT rvztag IS INITIAL ).
            IF ls_item-vztas GE '0'.
              CLEAR saldof.
              MOVE kopos-pswsl  TO saldof-waers.
              MOVE ls_item-dmshb  TO saldof-saldoh.
              MOVE ls_item-psshb  TO saldof-saldow.
              MOVE ls_item-wskta  TO saldof-salsk.
              MOVE ls_item-wrshn  TO saldof-saldn.
              COLLECT saldof.
            ENDIF.
          ENDIF.
        ENDIF.

        IF NOT pcccheck IS INITIAL
*        and save3_datum ne datum02.
        AND NOT pcc_nocheck IS INITIAL.
          pcc_waers = kopos-pswsl.
          bkpf = *bkpf.
          bseg = *bseg.
          CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
            EXPORTING
              iv_process  = process
              iv_date     = datum02
*             IV_DATE     = datum01
              iv_tabname  = 'BSEG'
              iv_fldname  = 'PSWBT'
              is_line     = bseg
              is_bkpf     = bkpf
*             IS_T001     =
            CHANGING
              cv_amount   = bseg-pswbt
              cv_currency = bseg-pswsl.

          kopos-pswsl = bseg-pswsl.
          kopos-pswbt = bseg-pswbt.
          IF pcc_waers NE kopos-pswsl.                      "2166308
            bsik-pswsl  = kopos-pswsl.                      "2166308
            bsik-pswbt  = kopos-pswbt.                      "2166308
            IF bsik-shkzg = 'S'.
              ls_item-psshb = kopos-pswbt.
            ELSE.
              ls_item-psshb = 0 - kopos-pswbt.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR saldoe.
        MOVE kopos-pswsl  TO saldoe-waers.
        MOVE ls_item-dmshb  TO saldoe-saldoh.
        MOVE ls_item-psshb  TO saldoe-saldow.
        IF  bsik-augdt IS INITIAL
        OR  bsik-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoe-salsk.
          MOVE ls_item-wrshn  TO saldoe-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoe-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoe-saldoo.
        ENDIF.
        COLLECT saldoe.

        IF bsik-sgtxt(1) NE '*'.                            "2166308
          ls_item-sgtxt = space.
        ELSE.
          ls_item-sgtxt = bsik-sgtxt+1.                     "2166308
        ENDIF.
        IF bsik-xblnr IS INITIAL.
          MOVE bsik-belnr TO ls_item-belegnum.
        ELSE.
          MOVE bsik-xblnr TO ls_item-belegnum.
        ENDIF.

        CLEAR save_blart.
        save_blart = bsik-blart.
        PERFORM read_t003t.
        save_bschl = bsik-bschl.
        PERFORM read_tbslt.
        IF NOT rxopos IS INITIAL
        OR NOT save_rxopol IS INITIAL.
          ls_item-corrid = co_rfkord_oil.
          ls_item-blart_desc = t003t-ltext.
          ls_item-bschl_desc = tbslt-ltext.
          APPEND ls_item TO lt_item.
*------------------------------item completed--------------------------*
        ENDIF.
        IF NOT xumskz IS INITIAL.
          AT END OF <umskz2>.
            IF NOT rxopos IS INITIAL
            OR NOT save_rxopol IS INITIAL.
              LOOP AT saldoz.
                CLEAR ls_sum.
                ls_sum-sum_id = co_rfkord_sdzo.
                ls_sum-genid_name = 'UMSKZ'.
                ls_sum-genid_value = <umskz2>.
                ls_sum-genid_text = t074t-ltext.
                MOVE saldoz-waers  TO ls_sum-waers.
                MOVE saldoz-saldow TO ls_sum-saldow.
                MOVE t001-waers    TO ls_sum-hwaer.
                MOVE saldoz-saldoh TO ls_sum-saldoh.
                MOVE saldoz-salsk  TO ls_sum-salsk.
                MOVE saldoz-saldn  TO ls_sum-saldn.
                MOVE saldoz-waerso TO ls_sum-waerso.
                MOVE saldoz-saldoo TO ls_sum-saldoo.
                APPEND ls_sum TO lt_sum.
              ENDLOOP.
            ENDIF.
          ENDAT.
        ENDIF.
      ENDLOOP.
    ENDIF.

    DESCRIBE TABLE saldoa LINES sldalines.
    IF sldalines GT 0.
      SORT saldoa BY waers.
      LOOP AT saldoa.
        CLEAR ls_sum.
        ls_sum-sum_id = co_rfkord_sda. "balance carried-forward
        MOVE saldoa-waers  TO ls_sum-waers.
        MOVE saldoa-saldow TO ls_sum-saldow.
        MOVE t001-waers    TO ls_sum-hwaer.
        MOVE saldoa-saldoh TO ls_sum-saldoh.
        IF NOT save_rxopol IS INITIAL.
          MOVE saldoa-salsk  TO ls_sum-salsk.
          MOVE saldoa-saldn  TO ls_sum-saldn.
        ENDIF.
        MOVE saldoa-waerso TO ls_sum-waerso.
        MOVE saldoa-saldoo TO ls_sum-saldoo.
        APPEND ls_sum TO lt_sum.
      ENDLOOP.
    ENDIF.

    IF save_koart = 'D'.
      IF NOT aidlines IS INITIAL.
        LOOP AT hbsid.
          IF *t001-bukrs NE hbsid-bukrs.
            SELECT SINGLE * FROM t001 INTO *t001
              WHERE bukrs = hbsid-bukrs.
          ENDIF.
          CLEAR ls_item-netdt.
          IF NOT save_rxekvb IS INITIAL.
            IF NOT xpkont IS INITIAL.
              AT NEW <konto3>.
                CLEAR   saldok.
                REFRESH saldok.
              ENDAT.
            ENDIF.
          ENDIF.
          IF NOT xumskz IS INITIAL.
            AT NEW <umskz3>.
              save_umskz = <umskz3>.
              IF NOT <umskz3> IS INITIAL.
                PERFORM read_t074t.
              ENDIF.
              CLEAR   saldoz.
              REFRESH saldoz.
            ENDAT.
          ENDIF.

          MOVE-CORRESPONDING hbsid TO bsid.
          MOVE-CORRESPONDING bsid TO ls_item.
          MOVE bsid-kunnr TO ls_item-konto.
          MOVE save_koart TO ls_item-koart.

          PERFORM fill_waehrungsfelder_bsidk.
          ls_item-wrshb = rf140-wrshb.
          ls_item-dmshb = rf140-dmshb.
          ls_item-wsshb = rf140-wsshb.
          ls_item-skshb = rf140-skshb.
          ls_item-wsshv = rf140-wsshv.
          ls_item-skshv = rf140-skshv.

          PERFORM fill_skonto_bsidk.
          ls_item-wskta = rf140-wskta.
          ls_item-wrshn = rf140-wrshn.

          CLEAR ls_item-waers.
          ls_item-waers = bsid-waers.

          IF bsid-shkzg = 'S'.
            ls_item-psshb = hbsid-pswbt.
            ls_item-zlshb = hbsid-nebtr.
          ELSE.
            ls_item-psshb = 0 - hbsid-pswbt.
            ls_item-zlshb = 0 - hbsid-nebtr.
          ENDIF.

*** expiring currencies: store old amounts
          ls_item_alw-waers_alw = ls_item-waers.
          ls_item_alw-pswsl_alw = ls_item-pswsl.
          ls_item_alw-wrshb_alw = ls_item-wrshb.
          ls_item_alw-dmshb_alw = ls_item-dmshb.
          ls_item_alw-wsshb_alw = ls_item-wsshb.
          ls_item_alw-skshb_alw = ls_item-skshb.
          ls_item_alw-wsshv_alw = ls_item-wsshv.
          ls_item_alw-skshv_alw = ls_item-skshv.
          ls_item_alw-wrshn_alw = ls_item-wrshn.
          ls_item_alw-psshb_alw = ls_item-psshb.
          MOVE *t001-waers TO ls_item_alw-hwaer_alw.

* provide old amounts in item structure (via ci-include)
          MOVE-CORRESPONDING ls_item_alw TO ls_item.

          alw_waers = bsid-waers.
          PERFORM currency_get_subsequent
                      USING
                         save_repid_alw
                         datum02
                         bsid-bukrs
                      CHANGING
                         alw_waers.
          IF alw_waers NE bsid-waers.
            bsid-waers = alw_waers.
            PERFORM curr_document_convert_bsid
                        USING
                           datum02
                           ls_item_alw-waers_alw
                           ls_item_alw-hwaer_alw
                           bsid-waers
                        CHANGING
                           bsid.

            PERFORM fill_waehrungsfelder_bsidk.
            ls_item-wrshb = rf140-wrshb.
            ls_item-dmshb = rf140-dmshb.
            ls_item-wsshb = rf140-wsshb.
            ls_item-skshb = rf140-skshb.
            ls_item-wsshv = rf140-wsshv.
            ls_item-skshv = rf140-skshv.

            PERFORM fill_skonto_bsidk.
            ls_item-wskta = rf140-wskta.
            ls_item-wrshn = rf140-wrshn.

            CLEAR ls_item-waers.
            ls_item-waers = bsid-waers.
            PERFORM convert_foreign_to_foreign_cur
                        USING
                           datum02
                           ls_item_alw-waers_alw
                           ls_item_alw-hwaer_alw
                           bsid-waers
                        CHANGING
                           hbsid-nebtr.
            IF bsid-shkzg = 'S'.
              ls_item-zlshb = hbsid-nebtr.
            ELSE.
              ls_item-zlshb = 0 - hbsid-nebtr.
            ENDIF.
          ENDIF.
*           IF  BSID-AUGDT IS INITIAL
*           OR  BSID-AUGDT GT SAVE2_DATUM.
          alw_waers = hbsid-pswsl.
          PERFORM currency_get_subsequent
                      USING
                         save_repid_alw
                         datum02
                         bsid-bukrs
                      CHANGING
                         alw_waers.
          IF alw_waers NE hbsid-pswsl.
            PERFORM convert_foreign_to_foreign_cur
                        USING
                           datum02
                           hbsid-pswsl
                           ls_item_alw-hwaer_alw
                           alw_waers
                        CHANGING
                           hbsid-pswbt.
            hbsid-pswsl = alw_waers.
            bsid-pswsl  = alw_waers.
            bsid-pswbt  = hbsid-pswbt.
            IF bsid-shkzg = 'S'.
              ls_item-psshb = hbsid-pswbt.
            ELSE.
              ls_item-psshb = 0 - hbsid-pswbt.
            ENDIF.
*           endif.
          ENDIF.
*         endif.

* Process Currency Change
          IF NOT pcccheck IS INITIAL.
*          process   = save_repid.
            process   = save_repid_alw.

            MOVE-CORRESPONDING hbsid TO bkpf.  "*BSID
            MOVE-CORRESPONDING hbsid TO bseg.  "*BSID + NEBTR
            bseg-koart = 'D'.
            *bkpf = bkpf.
            *bseg = bseg.
            pcc_waers = bkpf-waers.

            CALL FUNCTION 'FI_ITEMS_PROC_CURR_CHANGE'
              EXPORTING
                iv_process  = process
                iv_date     = datum02
                iv_tabname  = 'BSEG'
*               IS_KNA1     =
*               IS_LFA1     =
*               IS_BSEC     =
                is_bkpf     = bkpf
*               IS_T001     =
*               IV_NOCHECK  =
*           TABLES
*               IT_FIELDLIST              =
              CHANGING
                cs_line     = bseg
                cv_currency = bkpf-waers
              EXCEPTIONS
*               FIELD_NOT_AMOUNT          = 1
*               CURRENCY_MISSING          = 2
*               ERROR_IN_CONVERSION       = 3
                OTHERS      = 4.

            IF sy-subrc <> 0.
*           Implement suitable error handling here
            ELSE.
              IF pcc_waers NE bkpf-waers.
                MOVE-CORRESPONDING bkpf TO bsid.
                MOVE-CORRESPONDING bseg TO bsid.
                PERFORM fill_waehrungsfelder_bsidk.
                ls_item-wrshb = rf140-wrshb.
                ls_item-dmshb = rf140-dmshb.
                ls_item-wsshb = rf140-wsshb.
                ls_item-skshb = rf140-skshb.
                ls_item-wsshv = rf140-wsshv.
                ls_item-skshv = rf140-skshv.
                PERFORM fill_skonto_bsidk.
                ls_item-wskta = rf140-wskta.
                ls_item-wrshn = rf140-wrshn.
*              CLEAR RF140-WAERS.
*              RF140-WAERS = BSID-WAERS.
                CLEAR ls_item-waers.
                ls_item-waers = bsid-waers.
                hbsid-nebtr = bseg-nebtr.
                IF bsid-shkzg = 'S'.
                  ls_item-zlshb = hbsid-nebtr.
                ELSE.
                  ls_item-zlshb = 0 - hbsid-nebtr.
                ENDIF.
              ENDIF.
            ENDIF.

            pcc_waers = hbsid-pswsl.
            bkpf = *bkpf.
            bseg = *bseg.
            CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
              EXPORTING
                iv_process  = process
                iv_date     = datum02
                iv_tabname  = 'BSEG'
                iv_fldname  = 'PSWBT'
                is_line     = bseg
                is_bkpf     = bkpf
*               IS_T001     =
              CHANGING
                cv_amount   = bseg-pswbt
                cv_currency = bseg-pswsl.

            hbsid-pswsl = bseg-pswsl.
            hbsid-pswbt = bseg-pswbt.
            IF pcc_waers NE hbsid-pswsl.
              bsid-pswsl  = hbsid-pswsl.
              bsid-pswbt  = hbsid-pswbt.
              IF bsid-shkzg = 'S'.
                ls_item-psshb = hbsid-pswbt.
              ELSE.
                ls_item-psshb = 0 - hbsid-pswbt.
              ENDIF.
            ENDIF.
          ENDIF.

          CLEAR saldoe.
          MOVE hbsid-pswsl  TO saldoe-waers.
          MOVE ls_item-dmshb  TO saldoe-saldoh.
          MOVE ls_item-psshb  TO saldoe-saldow.
          IF bsid-augdt IS INITIAL
          OR bsid-augdt GT save2_datum.
            MOVE ls_item-wskta  TO saldoe-salsk.
            MOVE ls_item-wrshn  TO saldoe-saldn.
          ENDIF.
          IF NOT pcccheck IS INITIAL
          AND bseg-pswsl NE *bseg-pswsl
          AND NOT save_xpccss IS INITIAL.
            MOVE ls_item_alw-pswsl_alw  TO saldoe-waerso.
            MOVE ls_item_alw-psshb_alw  TO saldoe-saldoo.
          ENDIF.
          COLLECT saldoe.
          CLEAR saldoz.
          MOVE hbsid-pswsl  TO saldoz-waers.
          MOVE ls_item-dmshb  TO saldoz-saldoh.
          MOVE ls_item-psshb  TO saldoz-saldow.
          IF  bsid-augdt IS INITIAL
          OR  bsid-augdt GT save2_datum.
            MOVE ls_item-wskta  TO saldoz-salsk.
            MOVE ls_item-wrshn  TO saldoz-saldn.
          ENDIF.
          IF NOT pcccheck IS INITIAL
          AND bseg-pswsl NE *bseg-pswsl
          AND NOT save_xpccss IS INITIAL.
            MOVE ls_item_alw-pswsl_alw  TO saldoz-waerso.
            MOVE ls_item_alw-psshb_alw  TO saldoz-saldoo.
          ENDIF.
          COLLECT saldoz.
          CLEAR saldok.
          MOVE hbsid-kunnr  TO saldok-konto.
          MOVE hbsid-pswsl  TO saldok-waers.
          MOVE ls_item-dmshb  TO saldok-saldoh.
          MOVE ls_item-psshb  TO saldok-saldow.
          IF hbsid-shkzg = 'S'.
            MOVE ls_item-psshb  TO saldok-saldop.
            CLEAR saldok-saldon.
          ELSE.
            CLEAR saldok-saldop.
            MOVE ls_item-psshb  TO saldok-saldon.
          ENDIF.
          MOVE ls_item-zlshb  TO saldok-nebtr.
          IF NOT pcccheck IS INITIAL
          AND bseg-pswsl NE *bseg-pswsl
          AND NOT save_xpccss IS INITIAL.
            MOVE ls_item_alw-pswsl_alw  TO saldok-waerso.
            MOVE ls_item_alw-psshb_alw  TO saldok-saldoo.
          ENDIF.
          COLLECT saldok.
*          ENDIF.
          IF NOT rf140-vstid IS INITIAL.
            ls_item-vstid = rf140-vstid.
            IF hbsid-vztas IS INITIAL.
              CLEAR ls_item-vztas.
              ls_item-netdt = hbsid-netdt.
            ELSE.
              ls_item-vztas = hbsid-vztas.
              ls_item-netdt = hbsid-netdt.
            ENDIF.
            IF hbsid-augbl IS INITIAL
            OR ( hbsid-augdt GT rf140-vstid
                AND NOT rvztag IS INITIAL ).
              IF ls_item-vztas GE '0'.
                CLEAR saldof.
                MOVE hbsid-pswsl  TO saldof-waers.
                MOVE ls_item-dmshb  TO saldof-saldoh.
                MOVE ls_item-psshb  TO saldof-saldow.
                MOVE ls_item-wskta  TO saldof-salsk.
                MOVE ls_item-wrshn  TO saldof-saldn.
                COLLECT saldof.
              ENDIF.
            ENDIF.
          ENDIF.
          IF bsid-sgtxt(1) NE '*'.
            ls_item-sgtxt = space.
          ELSE.
            ls_item-sgtxt = bsid-sgtxt+1.
          ENDIF.
          IF bsid-xblnr IS INITIAL.
            MOVE bsid-belnr TO ls_item-belegnum.
          ELSE.
            MOVE bsid-xblnr TO ls_item-belegnum.
          ENDIF.

          CLEAR save_blart.
          save_blart = bsid-blart.
          PERFORM read_t003t.
          save_bschl = bsid-bschl.
          PERFORM read_tbslt.
*          IF NOT RXOPOS IS INITIAL.
          IF  ( save_rxekvb NE space
          AND   rxekep = '1'
          AND   bsid-kunnr NE save_kunnr )
          OR  ( save_rxekvb NE space
          AND   rxekep = '2' ).
          ELSE.
            ls_item-corrid = co_rfkord_ast. "Kontoauszug
            ls_item-blart_desc = t003t-ltext.
            ls_item-bschl_desc = tbslt-ltext.
            APPEND ls_item TO lt_item.
*------------------------------item completed--------------------------*
          ENDIF.
*          ENDIF.

          IF NOT xumskz IS INITIAL.
            AT END OF <umskz3>.
              LOOP AT saldoz.
                CLEAR ls_sum.
                ls_sum-sum_id = co_rfkord_sdza.
                ls_sum-genid_name = 'UMSKZ'.
                ls_sum-genid_value = <umskz3>.
                ls_sum-genid_text = t074t-ltext.
                MOVE saldoz-waers  TO ls_sum-waers.
                MOVE saldoz-saldow TO ls_sum-saldow.
                MOVE t001-waers    TO ls_sum-hwaer.
                MOVE saldoz-saldoh TO ls_sum-saldoh.
                MOVE saldoz-salsk  TO ls_sum-salsk.
                MOVE saldoz-saldn  TO ls_sum-saldn.
                MOVE saldoz-waerso TO ls_sum-waerso.
                MOVE saldoz-saldoo TO ls_sum-saldoo.
                APPEND ls_sum TO lt_sum.
              ENDLOOP.
            ENDAT.
          ENDIF.
          IF NOT save_rxekvb IS INITIAL.
            IF NOT xpkont IS INITIAL.
              AT END OF <konto3>.
                IF  rxekep IS INITIAL
                AND rxeksu IS INITIAL.
                ELSE.
                  SORT saldok BY waers.
                  LOOP AT saldok.
*                IF  ( RXEKEP = '1'
*                AND SALDOK-KONTO =  SAVE_KUNNR
*                AND     RXEKSU IS INITIAL ).
*                ELSE.
                    CLEAR ls_sum.
                    ls_sum-sum_id = co_rfkord_sdka.
                    MOVE saldok-konto  TO ls_sum-konto.
                    MOVE saldok-waers  TO ls_sum-waers.
                    MOVE saldok-saldow TO ls_sum-saldow.
                    MOVE t001-waers    TO ls_sum-hwaer.
                    MOVE saldok-saldoh TO ls_sum-saldoh.
                    MOVE saldok-saldop TO ls_sum-saldop.
                    MOVE saldok-saldon TO ls_sum-saldon.
                    MOVE saldok-nebtr  TO ls_sum-nebtr.
                    MOVE saldok-waerso TO ls_sum-waerso.
                    MOVE saldok-saldoo TO ls_sum-saldoo.
                    APPEND ls_sum TO lt_sum.
                  ENDLOOP.
                ENDIF.
              ENDAT.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ELSE.

      IF NOT aiklines IS INITIAL.
        LOOP AT hbsik.
          IF *t001-bukrs NE hbsik-bukrs.
            SELECT SINGLE * FROM t001 INTO *t001
              WHERE bukrs = hbsik-bukrs.
          ENDIF.
          CLEAR ls_item-netdt.
          IF NOT xumskz IS INITIAL.
            AT NEW <umskz4>.
              save_umskz = <umskz4>.
              IF NOT <umskz4>    IS INITIAL.
                PERFORM read_t074t.
              ENDIF.
              CLEAR   saldoz.
              REFRESH saldoz.
            ENDAT.
          ENDIF.

          MOVE-CORRESPONDING hbsik TO bsik.
          MOVE-CORRESPONDING bsik TO ls_item.
          MOVE bsik-lifnr TO ls_item-konto.
          MOVE save_koart TO ls_item-koart.

          PERFORM fill_waehrungsfelder_bsidk.
          ls_item-wrshb = rf140-wrshb.
          ls_item-dmshb = rf140-dmshb.
          ls_item-wsshb = rf140-wsshb.
          ls_item-skshb = rf140-skshb.
          ls_item-wsshv = rf140-wsshv.
          ls_item-skshv = rf140-skshv.

          PERFORM fill_skonto_bsidk.
          ls_item-wskta = rf140-wskta.
          ls_item-wrshn = rf140-wrshn.

          CLEAR ls_item-waers.
          ls_item-waers = bsik-waers.
*          IF BSIK-BSTAT NE 'S'.
          IF bsik-shkzg = 'S'.
            ls_item-psshb = hbsik-pswbt.
            ls_item-zlshb = hbsik-nebtr.
          ELSE.
            ls_item-psshb = 0 - hbsik-pswbt.
            ls_item-zlshb = 0 - hbsik-nebtr.
          ENDIF.

*** expiring currencies: store old amounts
          ls_item_alw-waers_alw = ls_item-waers.
          ls_item_alw-pswsl_alw = ls_item-pswsl.
          ls_item_alw-wrshb_alw = ls_item-wrshb.
          ls_item_alw-dmshb_alw = ls_item-dmshb.
          ls_item_alw-wsshb_alw = ls_item-wsshb.
          ls_item_alw-skshb_alw = ls_item-skshb.
          ls_item_alw-wsshv_alw = ls_item-wsshv.
          ls_item_alw-skshv_alw = ls_item-skshv.
          ls_item_alw-wrshn_alw = ls_item-wrshn.
          ls_item_alw-psshb_alw = ls_item-psshb.
          MOVE *t001-waers TO ls_item_alw-hwaer_alw.

* provide old amounts in item structure (via ci-include)
          MOVE-CORRESPONDING ls_item_alw TO ls_item.

          alw_waers = bsik-waers.
          PERFORM currency_get_subsequent
                      USING
                         save_repid_alw
                         datum02
                         bsik-bukrs
                      CHANGING
                         alw_waers.
          IF alw_waers NE bsik-waers.
            bsik-waers = alw_waers.
            PERFORM curr_document_convert_bsik
                        USING
                           datum02
                           ls_item_alw-waers_alw
                           ls_item_alw-hwaer_alw
                           bsik-waers
                        CHANGING
                           bsik.

            PERFORM fill_waehrungsfelder_bsidk.
            ls_item-wrshb = rf140-wrshb.
            ls_item-dmshb = rf140-dmshb.
            ls_item-wsshb = rf140-wsshb.
            ls_item-skshb = rf140-skshb.
            ls_item-wsshv = rf140-wsshv.
            ls_item-skshv = rf140-skshv.

            PERFORM fill_skonto_bsidk.
            ls_item-wskta = rf140-wskta.
            ls_item-wrshn = rf140-wrshn.

            CLEAR ls_item-waers.
            ls_item-waers = bsik-waers.
            PERFORM convert_foreign_to_foreign_cur
                        USING
                           datum02
                           ls_item_alw-waers_alw
                           ls_item_alw-hwaer_alw
                           bsik-waers
                        CHANGING
                           hbsik-nebtr.
            IF bsik-shkzg = 'S'.
              ls_item-zlshb = hbsik-nebtr.
            ELSE.
              ls_item-zlshb = 0 - hbsik-nebtr.
            ENDIF.
          ENDIF.
*           IF  BSIk-AUGDT IS INITIAL
*           OR  BSIk-AUGDT GT SAVE2_DATUM.
          alw_waers = hbsik-pswsl.
          PERFORM currency_get_subsequent
                      USING
                         save_repid_alw
                         datum02
                         bsik-bukrs
                      CHANGING
                         alw_waers.
          IF alw_waers NE hbsik-pswsl.
            PERFORM convert_foreign_to_foreign_cur
                        USING
                           datum02
                           hbsik-pswsl
                           ls_item_alw-hwaer_alw
                           alw_waers
                        CHANGING
                           hbsik-pswbt.
            hbsik-pswsl = alw_waers.
            bsik-pswsl  = alw_waers.
            bsik-pswbt  = hbsik-pswbt.
            IF bsik-shkzg = 'S'.
              ls_item-psshb = hbsik-pswbt.
            ELSE.
              ls_item-psshb = 0 - hbsik-pswbt.
            ENDIF.
*           endif.
          ENDIF.
*         endif.

* Process Currency Change
          IF NOT pcccheck IS INITIAL.
*          process   = save_repid.
            process   = save_repid_alw.

            MOVE-CORRESPONDING hbsik TO bkpf.  "*BSIk
            MOVE-CORRESPONDING hbsik TO bseg.  "*BSIk + NEBTR
            bseg-koart = 'K'.
            *bkpf = bkpf.
            *bseg = bseg.
            pcc_waers = bkpf-waers.

            CALL FUNCTION 'FI_ITEMS_PROC_CURR_CHANGE'
              EXPORTING
                iv_process  = process
                iv_date     = datum02
                iv_tabname  = 'BSEG'
*               IS_KNA1     =
*               IS_LFA1     =
*               IS_BSEC     =
                is_bkpf     = bkpf
*               IS_T001     =
*               IV_NOCHECK  =
*           TABLES
*               IT_FIELDLIST              =
              CHANGING
                cs_line     = bseg
                cv_currency = bkpf-waers
              EXCEPTIONS
*               FIELD_NOT_AMOUNT          = 1
*               CURRENCY_MISSING          = 2
*               ERROR_IN_CONVERSION       = 3
                OTHERS      = 4.

            IF sy-subrc <> 0.
*           Implement suitable error handling here
            ELSE.
              IF pcc_waers NE bkpf-waers.
                MOVE-CORRESPONDING bkpf TO bsik.
                MOVE-CORRESPONDING bseg TO bsik.
                PERFORM fill_waehrungsfelder_bsidk.
                ls_item-wrshb = rf140-wrshb.
                ls_item-dmshb = rf140-dmshb.
                ls_item-wsshb = rf140-wsshb.
                ls_item-skshb = rf140-skshb.
                ls_item-wsshv = rf140-wsshv.
                ls_item-skshv = rf140-skshv.
                PERFORM fill_skonto_bsidk.
                ls_item-wskta = rf140-wskta.
                ls_item-wrshn = rf140-wrshn.
*              CLEAR RF140-WAERS.
*              RF140-WAERS = BSID-WAERS.
                CLEAR ls_item-waers.
                ls_item-waers = bsik-waers.
                hbsik-nebtr = bseg-nebtr.
                IF bsik-shkzg = 'S'.
                  ls_item-zlshb = hbsik-nebtr.
                ELSE.
                  ls_item-zlshb = 0 - hbsik-nebtr.
                ENDIF.
              ENDIF.
            ENDIF.

            pcc_waers = hbsik-pswsl.
            bkpf = *bkpf.
            bseg = *bseg.
            CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
              EXPORTING
                iv_process  = process
                iv_date     = datum02
                iv_tabname  = 'BSEG'
                iv_fldname  = 'PSWBT'
                is_line     = bseg
                is_bkpf     = bkpf
*               IS_T001     =
              CHANGING
                cv_amount   = bseg-pswbt
                cv_currency = bseg-pswsl.

            hbsik-pswsl = bseg-pswsl.
            hbsik-pswbt = bseg-pswbt.
            IF pcc_waers NE hbsik-pswsl.
              bsid-pswsl  = hbsik-pswsl.
              bsid-pswbt  = hbsik-pswbt.
              IF bsik-shkzg = 'S'.
                ls_item-psshb = hbsik-pswbt.
              ELSE.
                ls_item-psshb = 0 - hbsik-pswbt.
              ENDIF.
            ENDIF.
          ENDIF.

          CLEAR saldoe.
          MOVE hbsik-pswsl  TO saldoe-waers.
          MOVE ls_item-dmshb  TO saldoe-saldoh.
          MOVE ls_item-psshb  TO saldoe-saldow.
          IF bsik-augdt IS INITIAL
          OR bsik-augdt GT save2_datum.
            MOVE ls_item-wskta  TO saldoe-salsk.
            MOVE ls_item-wrshn  TO saldoe-saldn.
          ENDIF.
          IF NOT pcccheck IS INITIAL
          AND bseg-pswsl NE *bseg-pswsl
          AND NOT save_xpccss IS INITIAL.
            MOVE ls_item_alw-pswsl_alw  TO saldoe-waerso.
            MOVE ls_item_alw-psshb_alw  TO saldoe-saldoo.
          ENDIF.
          COLLECT saldoe.
          CLEAR saldoz.
          MOVE hbsik-pswsl  TO saldoz-waers.
          MOVE ls_item-dmshb  TO saldoz-saldoh.
          MOVE ls_item-psshb  TO saldoz-saldow.
          IF  bsik-augdt IS INITIAL
          OR  bsik-augdt GT save2_datum.
            MOVE ls_item-wskta  TO saldoz-salsk.
            MOVE ls_item-wrshn  TO saldoz-saldn.
          ENDIF.
          IF NOT pcccheck IS INITIAL
          AND bseg-pswsl NE *bseg-pswsl
          AND NOT save_xpccss IS INITIAL.
            MOVE ls_item_alw-pswsl_alw  TO saldoz-waerso.
            MOVE ls_item_alw-psshb_alw  TO saldoz-saldoo.
          ENDIF.
          COLLECT saldoz.
*          ENDIF.
          IF NOT rf140-vstid IS INITIAL.
            ls_item-vstid = rf140-vstid.
            IF hbsik-vztas IS INITIAL.
              CLEAR ls_item-vztas.
              ls_item-netdt = hbsik-netdt.
            ELSE.
              ls_item-vztas = hbsik-vztas.
              ls_item-netdt = hbsik-netdt.
            ENDIF.
            IF hbsik-augbl IS INITIAL
            OR ( hbsik-augdt GT rf140-vstid
                AND NOT rvztag IS INITIAL ).
              IF ls_item-vztas GE '0'.
                CLEAR saldof.
                MOVE hbsik-pswsl  TO saldof-waers.
                MOVE ls_item-dmshb  TO saldof-saldoh.
                MOVE ls_item-psshb  TO saldof-saldow.
                MOVE ls_item-wskta  TO saldof-salsk.
                MOVE ls_item-wrshn  TO saldof-saldn.
                COLLECT saldof.
              ENDIF.
            ENDIF.
          ENDIF.
          IF bsik-sgtxt(1) NE '*'.
            ls_item-sgtxt = space.
          ELSE.
            ls_item-sgtxt = bsik-sgtxt+1.
          ENDIF.
          IF bsik-xblnr IS INITIAL.
            MOVE bsik-belnr TO ls_item-belegnum.
          ELSE.
            MOVE bsik-xblnr TO ls_item-belegnum.
          ENDIF.

          CLEAR save_blart.
          save_blart = bsik-blart.
          PERFORM read_t003t.
          save_bschl = bsik-bschl.
          PERFORM read_tbslt.
*          IF NOT RXOPOS IS INITIAL.
          ls_item-corrid = co_rfkord_ast.
          ls_item-blart_desc = t003t-ltext.
          ls_item-bschl_desc = tbslt-ltext.
          APPEND ls_item TO lt_item.
*------------------------------item completed--------------------------*
*          ENDIF.
          IF NOT xumskz IS INITIAL.
            AT END OF <umskz4>.
              LOOP AT saldoz.
                CLEAR ls_sum.
                ls_sum-sum_id = co_rfkord_sdza.
                ls_sum-genid_name = 'UMSKZ'.
                ls_sum-genid_value = <umskz4>.
                ls_sum-genid_text = t074t-ltext.
                MOVE saldoz-waers  TO ls_sum-waers.
                MOVE saldoz-saldow TO ls_sum-saldow.
                MOVE t001-waers    TO ls_sum-hwaer.
                MOVE saldoz-saldoh TO ls_sum-saldoh.
                MOVE saldoz-salsk  TO ls_sum-salsk.
                MOVE saldoz-saldn  TO ls_sum-saldn.
                MOVE saldoz-waerso TO ls_sum-waerso.
                MOVE saldoz-saldoo TO ls_sum-saldoo.
                APPEND ls_sum TO lt_sum.
              ENDLOOP.
            ENDAT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF save_rxopol IS INITIAL.
      DESCRIBE TABLE saldoe LINES sldelines.
      IF sldelines GT 0.
        SORT saldoe BY waers.
        LOOP AT saldoe.
          CLEAR ls_sum.
          ls_sum-sum_id = co_rfkord_sde.
          MOVE saldoe-waers  TO ls_sum-waers.
          MOVE saldoe-saldow TO ls_sum-saldow.
          MOVE t001-waers    TO ls_sum-hwaer.
          MOVE saldoe-saldoh TO ls_sum-saldoh.
          MOVE saldoe-salsk  TO ls_sum-salsk.
          MOVE saldoe-saldn  TO ls_sum-saldn.
          MOVE saldoe-waerso TO ls_sum-waerso.
          MOVE saldoe-saldoo TO ls_sum-saldoo.
          APPEND ls_sum TO lt_sum.
        ENDLOOP.
      ENDIF.
    ENDIF.

*------Offene Merkposten----------------------------------------------*
    IF save_koart = 'D'.

      LOOP AT dmpos.
        IF *t001-bukrs NE dmpos-bukrs.
          SELECT SINGLE * FROM t001 INTO *t001
            WHERE bukrs = dmpos-bukrs.
        ENDIF.
        CLEAR ls_item-netdt.
        IF NOT save_rxekvb IS INITIAL.
          IF NOT xpkont IS INITIAL.
            AT NEW <konto5>.
              CLEAR   saldok.
              REFRESH saldok.
            ENDAT.
          ENDIF.
        ENDIF.
        IF NOT xumskz IS INITIAL.
          AT NEW <umskz5>.
            save_umskz = <umskz5>.
            IF NOT <umskz5>    IS INITIAL.
              PERFORM read_t074t.
            ENDIF.
            CLEAR   saldoz.
            REFRESH saldoz.
          ENDAT.
        ENDIF.

        MOVE-CORRESPONDING dmpos TO bsid.
        MOVE-CORRESPONDING bsid TO ls_item.
        MOVE bsid-kunnr TO ls_item-konto.
        MOVE save_koart TO ls_item-koart.

        PERFORM fill_waehrungsfelder_bsidk.
        ls_item-wrshb = rf140-wrshb.
        ls_item-dmshb = rf140-dmshb.
        ls_item-wsshb = rf140-wsshb.
        ls_item-skshb = rf140-skshb.
        ls_item-wsshv = rf140-wsshv.
        ls_item-skshv = rf140-skshv.

        PERFORM fill_skonto_bsidk.
        ls_item-wskta = rf140-wskta.
        ls_item-wrshn = rf140-wrshn.

        CLEAR ls_item-waers.
        ls_item-waers = bsid-waers.
*        IF BSID-BSTAT NE 'S'.
        IF bsid-shkzg = 'S'.
          ls_item-psshb = dmpos-pswbt.
          ls_item-zlshb = dmpos-nebtr.
        ELSE.
          ls_item-psshb = 0 - dmpos-pswbt.
          ls_item-zlshb = 0 - dmpos-nebtr.
        ENDIF.

*** expiring currencies: store old amounts
        ls_item_alw-waers_alw = ls_item-waers.
        ls_item_alw-pswsl_alw = ls_item-pswsl.
        ls_item_alw-wrshb_alw = ls_item-wrshb.
        ls_item_alw-dmshb_alw = ls_item-dmshb.
        ls_item_alw-wsshb_alw = ls_item-wsshb.
        ls_item_alw-skshb_alw = ls_item-skshb.
        ls_item_alw-wsshv_alw = ls_item-wsshv.
        ls_item_alw-skshv_alw = ls_item-skshv.
        ls_item_alw-wrshn_alw = ls_item-wrshn.
        ls_item_alw-psshb_alw = ls_item-psshb.
        MOVE *t001-waers TO ls_item_alw-hwaer_alw.

* provide old amounts in item structure (via ci-include)
        MOVE-CORRESPONDING ls_item_alw TO ls_item.

        alw_waers = bsid-waers.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsid-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE bsid-waers.
          bsid-waers = alw_waers.
          PERFORM curr_document_convert_bsid
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsid-waers
                      CHANGING
                         bsid.

          PERFORM fill_waehrungsfelder_bsidk.
          ls_item-wrshb = rf140-wrshb.
          ls_item-dmshb = rf140-dmshb.
          ls_item-wsshb = rf140-wsshb.
          ls_item-skshb = rf140-skshb.
          ls_item-wsshv = rf140-wsshv.
          ls_item-skshv = rf140-skshv.

          PERFORM fill_skonto_bsidk.
          ls_item-wskta = rf140-wskta.
          ls_item-wrshn = rf140-wrshn.

          CLEAR ls_item-waers.
          ls_item-waers = bsid-waers.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsid-waers
                      CHANGING
                         dmpos-nebtr.
          IF bsid-shkzg = 'S'.
            ls_item-zlshb = dmpos-nebtr.
          ELSE.
            ls_item-zlshb = 0 - dmpos-nebtr.
          ENDIF.
        ENDIF.
*           IF  BSID-AUGDT IS INITIAL
*           OR  BSID-AUGDT GT SAVE2_DATUM.
        alw_waers = dmpos-pswsl.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsid-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE dmpos-pswsl.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         dmpos-pswsl
                         ls_item_alw-hwaer_alw
                         alw_waers
                      CHANGING
                         dmpos-pswbt.
          dmpos-pswsl = alw_waers.
          bsid-pswsl  = alw_waers.
          bsid-pswbt  = dmpos-pswbt.
          IF bsid-shkzg = 'S'.
            ls_item-psshb = dmpos-pswbt.
          ELSE.
            ls_item-psshb = 0 - dmpos-pswbt.
          ENDIF.
*           endif.
        ENDIF.
*         endif.

* Process Currency Change
        IF NOT pcccheck IS INITIAL.
*          process   = save_repid.
          process   = save_repid_alw.

          MOVE-CORRESPONDING dmpos TO bkpf.  "*BSID
          MOVE-CORRESPONDING dmpos TO bseg.  "*BSID + NEBTR
          bseg-koart = 'D'.
          *bkpf = bkpf.
          *bseg = bseg.
          pcc_waers = bkpf-waers.

          CALL FUNCTION 'FI_ITEMS_PROC_CURR_CHANGE'
            EXPORTING
              iv_process  = process
              iv_date     = datum02
              iv_tabname  = 'BSEG'
*             IS_KNA1     =
*             IS_LFA1     =
*             IS_BSEC     =
              is_bkpf     = bkpf
*             IS_T001     =
*             IV_NOCHECK  =
*           TABLES
*             IT_FIELDLIST              =
            CHANGING
              cs_line     = bseg
              cv_currency = bkpf-waers
            EXCEPTIONS
*             FIELD_NOT_AMOUNT          = 1
*             CURRENCY_MISSING          = 2
*             ERROR_IN_CONVERSION       = 3
              OTHERS      = 4.

          IF sy-subrc <> 0.
*           Implement suitable error handling here
          ELSE.
            IF pcc_waers NE bkpf-waers.
              MOVE-CORRESPONDING bkpf TO bsid.
              MOVE-CORRESPONDING bseg TO bsid.
              PERFORM fill_waehrungsfelder_bsidk.
              ls_item-wrshb = rf140-wrshb.
              ls_item-dmshb = rf140-dmshb.
              ls_item-wsshb = rf140-wsshb.
              ls_item-skshb = rf140-skshb.
              ls_item-wsshv = rf140-wsshv.
              ls_item-skshv = rf140-skshv.
              PERFORM fill_skonto_bsidk.
              ls_item-wskta = rf140-wskta.
              ls_item-wrshn = rf140-wrshn.
*              CLEAR RF140-WAERS.
*              RF140-WAERS = BSID-WAERS.
              CLEAR ls_item-waers.
              ls_item-waers = bsid-waers.
              dmpos-nebtr = bseg-nebtr.
              IF bsid-shkzg = 'S'.
                ls_item-zlshb = dmpos-nebtr.
              ELSE.
                ls_item-zlshb = 0 - dmpos-nebtr.
              ENDIF.
            ENDIF.
          ENDIF.

          pcc_waers = dmpos-pswsl.
          bkpf = *bkpf.
          bseg = *bseg.
          CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
            EXPORTING
              iv_process  = process
              iv_date     = datum02
              iv_tabname  = 'BSEG'
              iv_fldname  = 'PSWBT'
              is_line     = bseg
              is_bkpf     = bkpf
*             IS_T001     =
            CHANGING
              cv_amount   = bseg-pswbt
              cv_currency = bseg-pswsl.

          dmpos-pswsl = bseg-pswsl.
          dmpos-pswbt = bseg-pswbt.
          IF pcc_waers NE dmpos-pswsl.
            bsid-pswsl  = dmpos-pswsl.
            bsid-pswbt  = dmpos-pswbt.
            IF bsid-shkzg = 'S'.
              ls_item-psshb = dmpos-pswbt.
            ELSE.
              ls_item-psshb = 0 - dmpos-pswbt.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR saldom.
        MOVE dmpos-pswsl  TO saldom-waers.
        MOVE ls_item-dmshb  TO saldom-saldoh.
        MOVE ls_item-psshb  TO saldom-saldow.
        IF bsid-augdt IS INITIAL
        OR bsid-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoe-salsk.
          MOVE ls_item-wrshn  TO saldoe-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldom-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldom-saldoo.
        ENDIF.
        COLLECT saldom.
        CLEAR saldoz.
        MOVE dmpos-pswsl  TO saldoz-waers.
        MOVE ls_item-dmshb  TO saldoz-saldoh.
        MOVE ls_item-psshb  TO saldoz-saldow.
        IF  bsid-augdt IS INITIAL
        OR  bsid-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoz-salsk.
          MOVE ls_item-wrshn  TO saldoz-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoz-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoz-saldoo.
        ENDIF.
        COLLECT saldoz.
        CLEAR saldok.
        MOVE dmpos-kunnr  TO saldok-konto.
        MOVE dmpos-pswsl  TO saldok-waers.
        MOVE ls_item-dmshb  TO saldok-saldoh.
        MOVE ls_item-psshb  TO saldok-saldow.
        IF dmpos-shkzg = 'S'.
          MOVE ls_item-psshb  TO saldok-saldop.
          CLEAR saldok-saldon.
        ELSE.
          CLEAR saldok-saldop.
          MOVE ls_item-psshb  TO saldok-saldon.
        ENDIF.
        MOVE ls_item-zlshb  TO saldok-nebtr.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldok-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldok-saldoo.
        ENDIF.
        COLLECT saldok.
*        ENDIF.
        IF NOT rf140-vstid IS INITIAL.
          ls_item-vstid = rf140-vstid.
          IF dmpos-vztas IS INITIAL.
            CLEAR ls_item-vztas.
            ls_item-netdt = dmpos-netdt.
          ELSE.
            ls_item-vztas = dmpos-vztas.
            ls_item-netdt = dmpos-netdt.
          ENDIF.
          IF dmpos-augbl IS INITIAL
          OR ( dmpos-augdt GT rf140-vstid
              AND NOT rvztag IS INITIAL ).
            IF ls_item-vztas GE '0'.
              CLEAR saldof.
              MOVE dmpos-pswsl  TO saldof-waers.
              MOVE ls_item-dmshb  TO saldof-saldoh.
              MOVE ls_item-psshb  TO saldof-saldow.
              MOVE ls_item-wskta  TO saldof-salsk.
              MOVE ls_item-wrshn  TO saldof-saldn.
              COLLECT saldof.
            ENDIF.
          ENDIF.
        ENDIF.
        IF bsid-sgtxt(1) NE '*'.
          ls_item-sgtxt = space.
        ELSE.
          ls_item-sgtxt = bsid-sgtxt+1.
        ENDIF.
        IF bsid-xblnr IS INITIAL.
          MOVE bsid-belnr TO ls_item-belegnum.
        ELSE.
          MOVE bsid-xblnr TO ls_item-belegnum.
        ENDIF.

        CLEAR save_blart.
        save_blart = bsid-blart.
        PERFORM read_t003t.
        save_bschl = bsid-bschl.
        PERFORM read_tbslt.
*        IF NOT RXOPOS IS INITIAL.
        IF  ( save_rxekvb NE space
        AND   rxekep = '1'
        AND   bsid-kunnr NE save_kunnr )
        OR  ( save_rxekvb NE space
        AND   rxekep = '2' ).
        ELSE.
          ls_item-corrid = co_rfkord_mpo. "noted items
          ls_item-blart_desc = t003t-ltext.
          ls_item-bschl_desc = tbslt-ltext.
          APPEND ls_item TO lt_item.
*------------------------------item completed--------------------------*
        ENDIF.
*        ENDIF.
        IF NOT xumskz IS INITIAL.
          AT END OF <umskz5>.
            LOOP AT saldoz.
              CLEAR ls_sum.
              ls_sum-sum_id = co_rfkord_sdzm.
              ls_sum-genid_name = 'UMSKZ'.
              ls_sum-genid_value = <umskz5>.
              ls_sum-genid_text = t074t-ltext.
              MOVE saldoz-waers  TO ls_sum-waers.
              MOVE saldoz-saldow TO ls_sum-saldow.
              MOVE t001-waers    TO ls_sum-hwaer.
              MOVE saldoz-saldoh TO ls_sum-saldoh.
              MOVE saldoz-salsk  TO ls_sum-salsk.
              MOVE saldoz-saldn  TO ls_sum-saldn.
              MOVE saldoz-waerso TO ls_sum-waerso.
              MOVE saldoz-saldoo TO ls_sum-saldoo.
              APPEND ls_sum TO lt_sum.
            ENDLOOP.
          ENDAT.
        ENDIF.
        IF NOT save_rxekvb IS INITIAL.
          IF NOT xpkont IS INITIAL.
            AT END OF <konto5>.
              IF  rxekep IS INITIAL
              AND rxeksu IS INITIAL.
              ELSE.
                SORT saldok BY waers.
                LOOP AT saldok.
*              IF  ( RXEKEP = '1'
*              AND SALDOK-KONTO =  SAVE_KUNNR
*              AND     RXEKSU IS INITIAL ).
*              ELSE.
                  CLEAR ls_sum.
                  ls_sum-sum_id = co_rfkord_sdkm.
                  MOVE saldok-konto  TO ls_sum-konto.
                  MOVE saldok-waers  TO ls_sum-waers.
                  MOVE saldok-saldow TO ls_sum-saldow.
                  MOVE t001-waers    TO ls_sum-hwaer.
                  MOVE saldok-saldoh TO ls_sum-saldoh.
                  MOVE saldok-saldop TO ls_sum-saldop.
                  MOVE saldok-saldon TO ls_sum-saldon.
                  MOVE saldok-nebtr  TO ls_sum-nebtr.
                  MOVE saldok-waerso TO ls_sum-waerso.
                  MOVE saldok-saldoo TO ls_sum-saldoo.
                  APPEND ls_sum TO lt_sum.
*              ENDIF.
                ENDLOOP.
              ENDIF.
            ENDAT.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ELSE.

      LOOP AT kmpos.
        IF *t001-bukrs NE kmpos-bukrs.
          SELECT SINGLE * FROM t001 INTO *t001
            WHERE bukrs = kmpos-bukrs.
        ENDIF.
        CLEAR ls_item-netdt.
        IF NOT xumskz IS INITIAL.
          AT NEW <umskz6>.
            save_umskz = <umskz6>.
            IF NOT <umskz6>    IS INITIAL.
              PERFORM read_t074t.
            ENDIF.
            CLEAR   saldoz.
            REFRESH saldoz.
          ENDAT.
        ENDIF.

        MOVE-CORRESPONDING kmpos TO bsik.
        MOVE-CORRESPONDING bsik TO ls_item.
        MOVE bsik-lifnr TO ls_item-konto.
        MOVE save_koart TO ls_item-koart.

        PERFORM fill_waehrungsfelder_bsidk.
        ls_item-wrshb = rf140-wrshb.
        ls_item-dmshb = rf140-dmshb.
        ls_item-wsshb = rf140-wsshb.
        ls_item-skshb = rf140-skshb.
        ls_item-wsshv = rf140-wsshv.
        ls_item-skshv = rf140-skshv.

        PERFORM fill_skonto_bsidk.
        ls_item-wskta = rf140-wskta.
        ls_item-wrshn = rf140-wrshn.

        CLEAR ls_item-waers.
        ls_item-waers = bsik-waers.
*        IF BSIK-BSTAT NE 'S'.
        IF bsik-shkzg = 'S'.
          ls_item-psshb = kmpos-pswbt.
          ls_item-zlshb = kmpos-nebtr.
        ELSE.
          ls_item-psshb = 0 - kmpos-pswbt.
          ls_item-zlshb = 0 - kmpos-nebtr.
        ENDIF.

*** expiring currencies: store old amounts
        ls_item_alw-waers_alw = ls_item-waers.
        ls_item_alw-pswsl_alw = ls_item-pswsl.
        ls_item_alw-wrshb_alw = ls_item-wrshb.
        ls_item_alw-dmshb_alw = ls_item-dmshb.
        ls_item_alw-wsshb_alw = ls_item-wsshb.
        ls_item_alw-skshb_alw = ls_item-skshb.
        ls_item_alw-wsshv_alw = ls_item-wsshv.
        ls_item_alw-skshv_alw = ls_item-skshv.
        ls_item_alw-wrshn_alw = ls_item-wrshn.
        ls_item_alw-psshb_alw = ls_item-psshb.
        MOVE *t001-waers TO ls_item_alw-hwaer_alw.

* provide old amounts in item structure (via ci-include)
        MOVE-CORRESPONDING ls_item_alw TO ls_item.

        alw_waers = bsik-waers.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsik-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE bsik-waers.
          bsik-waers = alw_waers.
          PERFORM curr_document_convert_bsik
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsik-waers
                      CHANGING
                         bsik.

          PERFORM fill_waehrungsfelder_bsidk.
          ls_item-wrshb = rf140-wrshb.
          ls_item-dmshb = rf140-dmshb.
          ls_item-wsshb = rf140-wsshb.
          ls_item-skshb = rf140-skshb.
          ls_item-wsshv = rf140-wsshv.
          ls_item-skshv = rf140-skshv.

          PERFORM fill_skonto_bsidk.
          ls_item-wskta = rf140-wskta.
          ls_item-wrshn = rf140-wrshn.

          CLEAR ls_item-waers.
          ls_item-waers = bsik-waers.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         ls_item_alw-waers_alw
                         ls_item_alw-hwaer_alw
                         bsik-waers
                      CHANGING
                         kmpos-nebtr.
          IF bsik-shkzg = 'S'.
            ls_item-zlshb = kmpos-nebtr.
          ELSE.
            ls_item-zlshb = 0 - kmpos-nebtr.
          ENDIF.
        ENDIF.
*           IF  BSIk-AUGDT IS INITIAL
*           OR  BSIk-AUGDT GT SAVE2_DATUM.
        alw_waers = kmpos-pswsl.
        PERFORM currency_get_subsequent
                    USING
                       save_repid_alw
                       datum02
                       bsik-bukrs
                    CHANGING
                       alw_waers.
        IF alw_waers NE kmpos-pswsl.
          PERFORM convert_foreign_to_foreign_cur
                      USING
                         datum02
                         kmpos-pswsl
                         ls_item_alw-hwaer_alw
                         alw_waers
                      CHANGING
                         kmpos-pswbt.
          kmpos-pswsl = alw_waers.
          bsik-pswsl  = alw_waers.
          bsik-pswbt  = kmpos-pswbt.
          IF bsik-shkzg = 'S'.
            ls_item-psshb = kmpos-pswbt.
          ELSE.
            ls_item-psshb = 0 - kmpos-pswbt.
          ENDIF.
*           endif.
        ENDIF.
*         endif.

* Process Currency Change
        IF NOT pcccheck IS INITIAL.
*          process   = save_repid.
          process   = save_repid_alw.

          MOVE-CORRESPONDING kmpos TO bkpf.  "*BSIk
          MOVE-CORRESPONDING kmpos TO bseg.  "*BSIk + NEBTR
          bseg-koart = 'K'.
          *bkpf = bkpf.
          *bseg = bseg.
          pcc_waers = bkpf-waers.

          CALL FUNCTION 'FI_ITEMS_PROC_CURR_CHANGE'
            EXPORTING
              iv_process  = process
              iv_date     = datum02
              iv_tabname  = 'BSEG'
*             IS_KNA1     =
*             IS_LFA1     =
*             IS_BSEC     =
              is_bkpf     = bkpf
*             IS_T001     =
*             IV_NOCHECK  =
*           TABLES
*             IT_FIELDLIST              =
            CHANGING
              cs_line     = bseg
              cv_currency = bkpf-waers
            EXCEPTIONS
*             FIELD_NOT_AMOUNT          = 1
*             CURRENCY_MISSING          = 2
*             ERROR_IN_CONVERSION       = 3
              OTHERS      = 4.

          IF sy-subrc <> 0.
*           Implement suitable error handling here
          ELSE.
            IF pcc_waers NE bkpf-waers.
              MOVE-CORRESPONDING bkpf TO bsik.
              MOVE-CORRESPONDING bseg TO bsik.
              PERFORM fill_waehrungsfelder_bsidk.
              ls_item-wrshb = rf140-wrshb.
              ls_item-dmshb = rf140-dmshb.
              ls_item-wsshb = rf140-wsshb.
              ls_item-skshb = rf140-skshb.
              ls_item-wsshv = rf140-wsshv.
              ls_item-skshv = rf140-skshv.
              PERFORM fill_skonto_bsidk.
              ls_item-wskta = rf140-wskta.
              ls_item-wrshn = rf140-wrshn.
*              CLEAR RF140-WAERS.
*              RF140-WAERS = BSID-WAERS.
              CLEAR ls_item-waers.
              ls_item-waers = bsik-waers.
              kmpos-nebtr = bseg-nebtr.
              IF bsik-shkzg = 'S'.
                ls_item-zlshb = kmpos-nebtr.
              ELSE.
                ls_item-zlshb = 0 - kmpos-nebtr.
              ENDIF.
            ENDIF.
          ENDIF.

          pcc_waers = kmpos-pswsl.
          bkpf = *bkpf.
          bseg = *bseg.
          CALL FUNCTION 'OPEN_FI_PERFORM_00000119_P'
            EXPORTING
              iv_process  = process
              iv_date     = datum02
              iv_tabname  = 'BSEG'
              iv_fldname  = 'PSWBT'
              is_line     = bseg
              is_bkpf     = bkpf
*             IS_T001     =
            CHANGING
              cv_amount   = bseg-pswbt
              cv_currency = bseg-pswsl.

          kmpos-pswsl = bseg-pswsl.
          kmpos-pswbt = bseg-pswbt.
          IF pcc_waers NE kmpos-pswsl.
            bsik-pswsl  = kmpos-pswsl.
            bsik-pswbt  = kmpos-pswbt.
            IF bsik-shkzg = 'S'.
              ls_item-psshb = kmpos-pswbt.
            ELSE.
              ls_item-psshb = 0 - kmpos-pswbt.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR saldom.
        MOVE kmpos-pswsl  TO saldom-waers.
        MOVE ls_item-dmshb  TO saldom-saldoh.
        MOVE ls_item-psshb  TO saldom-saldow.
        IF bsik-augdt IS INITIAL
        OR bsik-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoe-salsk.
          MOVE ls_item-wrshn  TO saldoe-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldom-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldom-saldoo.
        ENDIF.
        COLLECT saldom.
        CLEAR saldoz.
        MOVE kmpos-pswsl  TO saldoz-waers.
        MOVE ls_item-dmshb  TO saldoz-saldoh.
        MOVE ls_item-psshb  TO saldoz-saldow.
        IF  bsik-augdt IS INITIAL
        OR  bsik-augdt GT save2_datum.
          MOVE ls_item-wskta  TO saldoz-salsk.
          MOVE ls_item-wrshn  TO saldoz-saldn.
        ENDIF.
        IF NOT pcccheck IS INITIAL
        AND bseg-pswsl NE *bseg-pswsl
        AND NOT save_xpccss IS INITIAL.
          MOVE ls_item_alw-pswsl_alw  TO saldoz-waerso.
          MOVE ls_item_alw-psshb_alw  TO saldoz-saldoo.
        ENDIF.
        COLLECT saldoz.
*        ENDIF.
        IF NOT rf140-vstid IS INITIAL.
          ls_item-vstid = rf140-vstid.
          IF kmpos-vztas IS INITIAL.
            CLEAR ls_item-vztas.
            ls_item-netdt = kmpos-netdt.
          ELSE.
            ls_item-vztas = kmpos-vztas.
            ls_item-netdt = kmpos-netdt.
          ENDIF.
          IF kmpos-augbl IS INITIAL
          OR ( kmpos-augdt GT ls_item-vstid
              AND NOT rvztag IS INITIAL ).
            IF ls_item-vztas GE '0'.
              CLEAR saldof.
              MOVE kmpos-pswsl  TO saldof-waers.
              MOVE ls_item-dmshb  TO saldof-saldoh.
              MOVE ls_item-psshb  TO saldof-saldow.
              MOVE ls_item-wskta  TO saldof-salsk.
              MOVE ls_item-wrshn  TO saldof-saldn.
              COLLECT saldof.
            ENDIF.
          ENDIF.
        ENDIF.

        IF bsik-sgtxt(1) NE '*'.
          ls_item-sgtxt = space.
        ELSE.
          ls_item-sgtxt = bsik-sgtxt+1.
        ENDIF.
        IF bsik-xblnr IS INITIAL.
          MOVE bsik-belnr TO ls_item-belegnum.
        ELSE.
          MOVE bsik-xblnr TO ls_item-belegnum.
        ENDIF.

        CLEAR save_blart.
        save_blart = bsik-blart.
        PERFORM read_t003t.
        save_bschl = bsik-bschl.
        PERFORM read_tbslt.
*        IF NOT RXOPOS IS INITIAL.
        ls_item-corrid = co_rfkord_mpo. "noted items
        ls_item-blart_desc = t003t-ltext.
        ls_item-bschl_desc = tbslt-ltext.
        APPEND ls_item TO lt_item.
*------------------------------item completed--------------------------*
*        ENDIF.
        IF NOT xumskz IS INITIAL.
          AT END OF <umskz6>.
            LOOP AT saldoz.
              CLEAR ls_sum.
              ls_sum-sum_id = co_rfkord_sdzm.
              ls_sum-genid_name = 'UMSKZ'.
              ls_sum-genid_value = <umskz6>.
              ls_sum-genid_text = t074t-ltext.
              MOVE saldoz-waers  TO ls_sum-waers.
              MOVE saldoz-saldow TO ls_sum-saldow.
              MOVE t001-waers    TO ls_sum-hwaer.
              MOVE saldoz-saldoh TO ls_sum-saldoh.
              MOVE saldoz-salsk  TO ls_sum-salsk.
              MOVE saldoz-saldn  TO ls_sum-saldn.
              MOVE saldoz-waerso TO ls_sum-waerso.
              MOVE saldoz-saldoo TO ls_sum-saldoo.
              APPEND ls_sum TO lt_sum.
            ENDLOOP.
          ENDAT.
        ENDIF.
      ENDLOOP.
    ENDIF.

    DESCRIBE TABLE saldom LINES sldmlines.
    IF sldmlines GT 0.
      SORT saldom BY waers.
      LOOP AT saldom.
        CLEAR ls_sum.
        ls_sum-sum_id = co_rfkord_sdm.
        MOVE saldom-waers  TO ls_sum-waers.
        MOVE saldom-saldow TO ls_sum-saldow.
        MOVE t001-waers    TO ls_sum-hwaer.
        MOVE saldom-saldoh TO ls_sum-saldoh.
        MOVE saldom-salsk  TO ls_sum-salsk.
        MOVE saldom-saldn  TO ls_sum-saldn.
        MOVE saldom-waerso TO ls_sum-waerso.
        MOVE saldom-saldoo TO ls_sum-saldoo.
        APPEND ls_sum TO lt_sum.
      ENDLOOP.
    ENDIF.


*------Summe fällige Posten und OP-Rasterung--------------------------*

    IF NOT rf140-vstid IS INITIAL.
      DESCRIBE TABLE saldof LINES sldflines.
      IF sldflines GT 0.
        SORT saldof BY waers.
        LOOP AT saldof.
          CLEAR ls_sum.
          ls_sum-sum_id = co_rfkord_sdf.
          MOVE saldof-waers  TO ls_sum-waers.
          MOVE saldof-saldow TO ls_sum-saldow.
          MOVE t001-waers    TO ls_sum-hwaer.
          MOVE saldof-saldoh TO ls_sum-saldoh.
          MOVE saldof-salsk  TO ls_sum-salsk.
          MOVE saldof-saldn  TO ls_sum-saldn.
          APPEND ls_sum TO lt_sum.
        ENDLOOP.
      ENDIF.

      CLEAR sldflines.
      DESCRIBE TABLE rtab LINES sldflines.
      IF sldflines GT 0.

        CLEAR ls_rtab.
        REFRESH lt_rtab[].

        LOOP AT rtab.
          MOVE-CORRESPONDING rtab TO ls_rtab.
          ls_rtab-rpt01 = rf140-rpt01.
          ls_rtab-rpt02 = rf140-rpt02.
          ls_rtab-rpt03 = rf140-rpt03.
          ls_rtab-rpt04 = rf140-rpt04.
          ls_rtab-rpt05 = rf140-rpt05.
          ls_rtab-rpt06 = rf140-rpt06.
          ls_rtab-rpt07 = rf140-rpt07.
          ls_rtab-rpt08 = rf140-rpt08.
          ls_rtab-rpt09 = rf140-rpt09.
          ls_rtab-rpt10 = rf140-rpt10.
          APPEND ls_rtab TO lt_rtab.
        ENDLOOP.

      ENDIF.
    ENDIF.

* provide subsidary information in address
    IF  NOT xzent  IS INITIAL.
*    AND     HXDEZV IS INITIAL.
      DESCRIBE TABLE filialen LINES sy-tfill.
      LOOP AT filialen.
        CLEAR fiadr.
        CLEAR ls_address.
        IF save_koart = 'D'.
          LOOP AT hkna1
            WHERE kunnr = filialen-filiale.
            MOVE-CORRESPONDING hkna1 TO fiadr.
            MOVE hkna1-kunnr         TO fiadr-konto.
            MOVE t001-land1          TO fiadr-inlnd.
          ENDLOOP.
          LOOP AT hknb1
            WHERE kunnr = filialen-filiale
            AND   bukrs = save_bukrs.
            MOVE-CORRESPONDING hknb1 TO fiadr.
          ENDLOOP.
        ELSE.
          LOOP AT hlfa1
            WHERE lifnr = filialen-filiale.
            MOVE-CORRESPONDING hlfa1 TO fiadr.
            MOVE hlfa1-lifnr         TO fiadr-konto.
            MOVE t001-land1          TO fiadr-inlnd.
          ENDLOOP.
          LOOP AT hlfb1
            WHERE lifnr = filialen-filiale
            AND   bukrs = save_bukrs.
            MOVE-CORRESPONDING hlfb1 TO fiadr.
          ENDLOOP.
*            ENDIF.
        ENDIF.

        MOVE-CORRESPONDING fiadr TO ls_address.

        MOVE-CORRESPONDING fiadr TO ls_adrs.
        IF NOT dkadr-adrnr IS INITIAL.
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              address_type      = '1'
              address_number    = fiadr-adrnr
              sender_country    = fiadr-inlnd
*             PERSON_NUMBER     = ' '
            IMPORTING
              address_printform = ls_adrs_print
*             NUMBER_OF_USED_LINES                 =
            EXCEPTIONS
              OTHERS            = 1.
          MOVE-CORRESPONDING ls_adrs_print TO ls_address.
        ELSE.
          MOVE-CORRESPONDING fiadr TO ls_adrs.
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              adrswa_in  = ls_adrs
            IMPORTING
              adrswa_out = ls_adrs
*             NUMBER_OF_USED_LINES                 =
            EXCEPTIONS
              OTHERS     = 1.
          MOVE-CORRESPONDING ls_adrs TO ls_address.
        ENDIF.

        MOVE co_rfkord_fil TO ls_address-corrid.
        APPEND ls_address TO lt_address.

      ENDLOOP.
    ENDIF.


*--------------------payment medium------------------------------------*
    IF NOT save_rzlsch IS INITIAL.

      REFRESH lt_paymo[].
      DESCRIBE TABLE saldoe LINES sldelines.
      IF sldelines = 1.
        paymi-bukrs = save_bukrs.
        paymi-zlsch = save_rzlsch.
        paymi-nacha = finaa-nacha.
        paymi-applk = 'FI-FI'.
        paymi-zbukr = save_bukrs.
        paymi-zadrt = '01'.
        MOVE-CORRESPONDING dkadr TO paymi.
        IF save_koart = 'D'.
          paymi-kunnr = save_kunnr.
        ELSE.
          paymi-lifnr = save_lifnr.
        ENDIF.
        paymi-avsid = rf140-avsid.
        paymi-datum = syst-datum.
        paymi-vorid = '0001'.

        READ TABLE saldoe INDEX 1.
        paymi-waers = saldoe-waers.
        IF saldoe-saldow GT 0.
          paymi-shkzg = 'S'.
        ELSE.
          paymi-shkzg = 'H'.
        ENDIF.
        paymi-rbbtr = saldoe-saldoh.
        paymi-rwbbt = saldoe-saldow.
        paymi-rwskt = saldoe-salsk.

        REFRESH hfimsg.
        CLEAR   hfimsg.

        CALL FUNCTION 'PAYMENT_MEDIUM_DATA'
          EXPORTING
            i_paymi = paymi
          IMPORTING
            e_paymo = paymo
          TABLES
            t_fimsg = hfimsg
          EXCEPTIONS
            OTHERS  = 4.
        IF sy-subrc NE 0.
          xkausgzt = 'X'.
        ENDIF.

* provide paymo
        APPEND paymo TO lt_paymo.

        LOOP AT hfimsg.
          CALL FUNCTION 'FI_MESSAGE_COLLECT'
            EXPORTING
              i_fimsg = hfimsg
*             I_XAPPN = ' '
            EXCEPTIONS
*             MSGID_MISSING = 1
*             MSGNO_MISSING = 2
*             MSGTY_MISSING = 3
              OTHERS  = 4.
          IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
          ENDIF.
        ENDLOOP.

      ELSE.
        CLEAR paymi.
        CLEAR paymo.
      ENDIF.
    ENDIF.

    xprint = 'X'.

    CHECK save_ftype = '3'.

* get docparams
    PERFORM fill_docparams_pdf USING    language
                                    dkadr-land1             "2170652
                                    h_archive_index
                           CHANGING fp_docparams.
* Begin of Change SRBOSE
    REFRESH: i_bsid,
             i_bseg,
             i_final.

    PERFORM f_get_bsid_bseg USING hbsid[]
                         CHANGING i_bsid
                                  i_bseg.

    PERFORM f_populate_data USING i_bsid
                                  i_bseg
                         CHANGING i_final.
* End of Change SRBOSE

    IF NOT save_fm_name IS INITIAL AND i_final[] IS NOT INITIAL.
* call the generated function module
* Begin of Change Pavan
*      CALL FUNCTION save_fm_name
*        EXPORTING
*          /1bcdwb/docparams = fp_docparams
*          ls_header         = ls_header
*          lt_address        = lt_address
*          lt_item           = lt_item
*          lt_sum            = lt_sum
*          lt_rtab           = lt_rtab
*          lt_paymo          = lt_paymo
**        importing                                               "1636232
*          /1BCDWB/FORMOUTPUT = Ls_formoutput                    "1636232

***      Begin of change SRBOSE
      gs_docparams = fp_docparams.

      CALL FUNCTION save_fm_name    "'/1BCDWB/SM00000079'
        EXPORTING
          /1bcdwb/docparams  = fp_docparams
          dkadr              = dkadr
          hdbukrs            = hdbukrs
          im_total_value     = v_total
          im_final           = i_final
          bkpf               = bkpf
          ls_header          = ls_header
          im_currency        = v_currency
          im_currency_table  = i_currency
        IMPORTING
          /1bcdwb/formoutput = ls_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        PERFORM message_pdf.
      ELSE.                                                 "1636232
        PERFORM send_pdf USING fp_docparams-daratab         "1636232
                               ls_formoutput.               "1636232
      ENDIF.
    ELSE.
** error
    ENDIF.
  ENDIF.                               "xkausg.
ENDFORM.                    "AUSGABE_KONTOAUSZUG

*&---------------------------------------------------------------------*
*&      Form  check_output
*&---------------------------------------------------------------------*
*       created by note 854148. Statements activating indicator XKAUSG
*       are moved from FORM AUSGABE_KONTOAUSZUG in order to avoid that
*       a fax cover sheet is printed without corresponding output of
*       open item list or customer statement
*----------------------------------------------------------------------*

FORM check_output .
* CLEAR xkausg.
  CLEAR aidlines.
  CLEAR aiklines.
  CLEAR aoplines.
  CLEAR amplines.
  IF save_rxopol IS INITIAL.
    IF save_koart = 'D'.
      DESCRIBE TABLE hbsid LINES aidlines.
      DESCRIBE TABLE dopos LINES aoplines.
      DESCRIBE TABLE dmpos LINES amplines.
      IF aidlines IS INITIAL.
        IF NOT aoplines IS INITIAL
        OR NOT amplines IS INITIAL.
          IF rxkpos IS INITIAL.
            xkausg = 'X'.
          ENDIF.
        ELSE.
          xkausg = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF save_koart = 'K'.
      DESCRIBE TABLE hbsik LINES aiklines.
      DESCRIBE TABLE kopos LINES aoplines.
      DESCRIBE TABLE kmpos LINES amplines.
      IF aiklines IS INITIAL.
        IF NOT aoplines IS INITIAL
        OR NOT amplines IS INITIAL.
          IF rxkpos IS INITIAL.
            xkausg = 'X'.
          ENDIF.
        ELSE.
          xkausg = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
    IF save_koart = 'D'.
      DESCRIBE TABLE dopos LINES aoplines.
      DESCRIBE TABLE dmpos LINES amplines.
    ELSE.
      DESCRIBE TABLE kopos LINES aoplines.
      DESCRIBE TABLE kmpos LINES amplines.
    ENDIF.
    IF aoplines IS INITIAL.
      IF NOT amplines IS INITIAL.
      ELSE.
        IF rxkpos IS INITIAL.
          xkausg = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " check_output
