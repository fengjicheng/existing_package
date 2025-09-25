*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_JKSESCHED_CHECK_VER_05
* PROGRAM DESCRIPTION: As per SAP TICKET 280454 / 2020 (REPORT z_jksesched_check_ver_5)
* This report checks if the JKSECHED records is valid
* Following checks are handled:
* a) Not valid, can be deleted
* b) JKSECONTRINDEX not available, VBAP not available -> probaby deleted
* c) JKSECONTRINDEX not available, VBAP available but AUART is not I-SM AUART
*                   (ism_contract <> '02')
* d) JKSECONTRINDEX not available, VBAP available but AUART is I-SM AUART
*                   (ism_contract = '02'), but TRVOG <> 4 (no contract)
* e) JKSECONTRINDEX not available, VBAP available, check contract type
* f) Not valid, but order exists, can not be deleted
*    a) No change document data available WRITE: / 'Order exists, but not valid...a)'
*    b)  no VENDDAT/VBEGDAT field changes available WRITE: / 'Order exists,
*                   but not valid...b)'
*    c) generated orde not found             WRITE: / 'Order exists, but not valid...c)'
*    d) no order found or more than one order found WRITE: / 'Order exists,
*                   but not valid... d)'
*    e) Changedocument available, validity was changed, but still not valid
*                   WRITE: / 'Order exists, but not valid...e)'
*    f) Changedocument available, but didn't influence the validity
*                   WRITE: / 'Order exists, but not valid...f)'
* g) Product changed, can be deleted
*
*
* DEVELOPER:           Nikhiesh Palla (NPALLA).
* CREATION DATE:       05/03/2020
* OBJECT ID:           Z Program per SAP TICKET 280454 / 2020 (REPORT z_jksesched_check_ver_5)
* TRANSPORT NUMBER(S): ED2K915073
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*----------------------------------------------------------------------*
REPORT ZQTCR_JKSESCHED_CHECK_VER_05.

TABLES: jksesched.

DATA: lv_cursor TYPE cursor.
DATA: lt_jksesched TYPE TABLE OF jksesched.
DATA: lt_jksesched_del TYPE TABLE OF jksesched.
DATA: lt_jksecontrindex TYPE SORTED TABLE OF jksecontrindex WITH UNIQUE KEY vbeln posnr.
DATA: ls_jksecontrindex TYPE jksecontrindex.
DATA: lv_valid TYPE c.
DATA: ls_vbegdat TYPE veda-vbegdat.
DATA: ls_venddat TYPE veda-venddat.
DATA: lt_jksenip TYPE SORTED TABLE OF jksenip WITH UNIQUE KEY id.
DATA: ls_jksenip TYPE jksenip.
DATA: lv_counter TYPE i.
DATA: lv_objectid TYPE cdhdr-objectid.
DATA: lv_tablekey TYPE cdpos-tabkey.
DATA: lv_tablename TYPE cdpos-tabname.
DATA: lt_editpos TYPE TABLE OF cdred.
DATA: ls_editpos TYPE cdred.
DATA: lt_jkseflow TYPE TABLE OF jkseflow.
DATA: ls_jkseflow TYPE jkseflow.
DATA: ls_vbap TYPE vbap.
DATA: lv_date_from TYPE jksecontrindex-valid_until.
DATA: lv_date_until TYPE jksecontrindex-valid_until.
DATA: lv_counter_del_table TYPE i.
DATA: lv_counter_vbap_missing TYPE i.
DATA: lv_counter_auart_noism_missing TYPE i.
DATA: lv_counter_auart_ism_missing TYPE i.
DATA: lv_counter_auart_check TYPE i.
DATA: lv_counter_order_exists TYPE i.
DATA: ls_tvak TYPE tvak.
DATA: ls_vbak TYPE vbak.
DATA: lv_product_ok TYPE abap_bool.
DATA: lv_counter_product_changed TYPE i.

SELECT-OPTIONS: s_vbeln FOR jksesched-vbeln,
                s_issue FOR jksesched-issue,
                s_prod  FOR jksesched-product.
SELECTION-SCREEN BEGIN OF BLOCK 100 WITH FRAME TITLE bl_100.
PARAMETERS: p_del TYPE abap_bool.
SELECTION-SCREEN END OF BLOCK 100.

SELECTION-SCREEN BEGIN OF BLOCK 200 WITH FRAME TITLE bl_200.
PARAMETERS: p_sum TYPE abap_bool.
SELECTION-SCREEN END OF BLOCK 200.

INITIALIZATION.
  bl_100 = 'DB Update: JKSESCHED records will be deleted: P_DEL = X'.
  bl_200 = 'Log only summary: P_SUM = X'.

START-OF-SELECTION.

  IF p_del = abap_false.
    WRITE: 'Testrun', sy-datum, sy-uzeit.
  ELSE.
    WRITE: 'With DB update', sy-datum, sy-uzeit.
  ENDIF.

  OPEN CURSOR WITH HOLD lv_cursor                       "#EC CI_NOFIELD
    FOR SELECT *
      FROM jksesched
      WHERE vbeln IN s_vbeln
      AND   issue IN s_issue
      AND   product IN s_prod.

  DO.
*   get the data from the database:
    FETCH NEXT CURSOR lv_cursor INTO lt_jksesched
      PACKAGE SIZE 100.
    IF sy-subrc NE 0 .
      CLOSE CURSOR lv_cursor.
      EXIT .
    ENDIF .
    CLEAR lt_jksesched_del.
    CLEAR lt_jksecontrindex.
    CLEAR lt_jksenip.

    SELECT * FROM jksecontrindex
      INTO TABLE lt_jksecontrindex
      FOR ALL ENTRIES IN lt_jksesched
      WHERE vbeln = lt_jksesched-vbeln
      AND   posnr = lt_jksesched-posnr.

    SELECT * FROM jksenip
      INTO TABLE lt_jksenip
      FOR ALL ENTRIES IN lt_jksesched
      WHERE id = lt_jksesched-nip.

    LOOP AT lt_jksesched ASSIGNING FIELD-SYMBOL(<fs_jksesched>).
      READ TABLE lt_jksenip INTO ls_jksenip
        WITH TABLE KEY id = <fs_jksesched>-nip.

      READ TABLE lt_jksecontrindex INTO ls_jksecontrindex
        WITH TABLE KEY vbeln = <fs_jksesched>-vbeln
                       posnr = <fs_jksesched>-posnr.
      IF sy-subrc <> 0.
* contract not available.
        SELECT SINGLE * FROM vbap
          INTO ls_vbap
          WHERE vbeln = <fs_jksesched>-vbeln
          AND   posnr = <fs_jksesched>-posnr.
        IF sy-subrc <> 0.
* VBAP entrie not available -> probaby deleted
          IF p_sum IS INITIAL.
            WRITE: / 'b) VBAP missing:', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
          ENDIF.
          APPEND <fs_jksesched> TO lt_jksesched_del.
          lv_counter_vbap_missing =  lv_counter_vbap_missing + 1.
        ELSE.
*        else check order type?
          SELECT SINGLE * FROM vbak
            INTO ls_vbak
            WHERE vbeln = <fs_jksesched>-vbeln.
          IF sy-subrc = 0.
            SELECT SINGLE * FROM tvak
              INTO ls_tvak
              WHERE auart = ls_vbak-auart.
            IF ls_tvak-ism_contract <> '02' AND
               ls_tvak-trvog = '4'.
* no IS-Media Series contract
              IF p_sum IS INITIAL.
                WRITE: / 'c) no IS-M document type', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence, ls_tvak-auart.
              ENDIF.
              APPEND <fs_jksesched> TO lt_jksesched_del.
              lv_counter_auart_noism_missing =  lv_counter_auart_noism_missing + 1.
            ELSEIF ls_tvak-ism_contract = '02' AND
                   ls_tvak-trvog <> '4'.
              IF p_sum IS INITIAL.
                WRITE: / 'd) IS-M document type, but no contract', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence, ls_tvak-auart.
              ENDIF.
              APPEND <fs_jksesched> TO lt_jksesched_del.
              lv_counter_auart_ism_missing =  lv_counter_auart_ism_missing + 1.
            ELSE.
              IF p_sum IS INITIAL.
                WRITE: / 'e) check contract type', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence, ls_tvak-auart.
              ENDIF.
              APPEND <fs_jksesched> TO lt_jksesched_del.
              lv_counter_auart_check =  lv_counter_auart_check + 1.
            ENDIF.
          ENDIF.
        ENDIF.
        CONTINUE.
      ENDIF.

      PERFORM check_product USING ls_jksenip
                                  ls_jksecontrindex
                            CHANGING lv_product_ok.
      IF lv_product_ok = abap_false.
        APPEND <fs_jksesched> TO lt_jksesched_del.
        lv_counter_product_changed = lv_counter_product_changed + 1.
        IF p_sum IS INITIAL.
          WRITE: / 'g) Product changed:', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
        ENDIF.
        CONTINUE.
      ENDIF.

*       Prüfen der Gültigkeit des Kontrats gegen Nip-Daten
      PERFORM check_validity_contract USING    ls_vbegdat
                                               ls_venddat
                                               ls_jksecontrindex-valid_from
                                               ls_jksecontrindex-valid_until
                                               ls_jksenip-sub_valid_from
                                               ls_jksenip-sub_valid_until
                                      CHANGING lv_valid.
      IF lv_valid = abap_false AND <fs_jksesched>-xorder_created = 'X'.
* not valid anymore, in case order was already created check the changes
* of the contract validity date within change documents
        CLEAR lt_jkseflow.
        SELECT * FROM jkseflow
          INTO TABLE lt_jkseflow
          WHERE nip = ls_jksenip-id
          AND   contract_vbeln = <fs_jksesched>-vbeln
          AND   contract_posnr = <fs_jksesched>-posnr
          AND   issue          = <fs_jksesched>-issue.
        IF lines( lt_jkseflow ) = 1.
          READ TABLE lt_jkseflow INTO ls_jkseflow INDEX 1.

          SELECT SINGLE * FROM vbap
            INTO ls_vbap
            WHERE vbeln = ls_jkseflow-vbelnorder
            AND   posnr = ls_jkseflow-posnrorder.
          IF sy-subrc = 0.
            lv_objectid = <fs_jksesched>-vbeln.
            CONCATENATE sy-mandt <fs_jksesched>-vbeln <fs_jksesched>-posnr INTO lv_tablekey.
            lv_tablename = 'VEDA'.

            CLEAR lv_date_until.
            CLEAR lv_date_from.
* ermitteln Änderung VENDDAT
            CLEAR lt_editpos.
            CALL FUNCTION 'CHANGEDOCUMENT_READ'
              EXPORTING
*               ARCHIVE_HANDLE             = 0
*               CHANGENUMBER               = ' '
*               DATE_OF_CHANGE             = '00000000'
                objectclass                = 'VERKBELEG'
                objectid                   = lv_objectid
                tablekey                   = lv_tablekey
                tablename                  = lv_tablename
              TABLES
                editpos                    = lt_editpos
              EXCEPTIONS
                no_position_found          = 1
                wrong_access_to_archive    = 2
                time_zone_conversion_error = 3
                OTHERS                     = 4.
            IF sy-subrc <> 0.
* No change document data available
              IF p_sum IS INITIAL.
                WRITE: / 'Order exists, but not valid...a)', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
              ENDIF.
              lv_counter_order_exists = lv_counter_order_exists + 1.
              CONTINUE.
            ELSE.
              DELETE lt_editpos WHERE fname <> 'VENDDAT' AND
                                      fname <> 'VBEGDAT'.
              SORT lt_editpos BY udate utime.
              IF lt_editpos IS INITIAL.
* no VENDDAT/VBEGDAT field changes available
                IF p_sum IS INITIAL.
                  WRITE: / 'Order exists, but not valid...b)', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
                ENDIF.
                lv_counter_order_exists = lv_counter_order_exists + 1.
                CONTINUE.
              ENDIF.
              LOOP AT lt_editpos INTO ls_editpos.
                IF ls_editpos-udate < ls_vbap-erdat OR (
                   ls_editpos-udate = ls_vbap-erdat AND
                   ls_editpos-utime < ls_vbap-erzet ).
                  IF ls_editpos-fname = 'VENDDAT'.
                    CONCATENATE ls_editpos-f_new+6
                                ls_editpos-f_new(2)
                                ls_editpos-f_new+3(2)
                                INTO lv_date_until.
                  ELSEIF ls_editpos-fname = 'VBEGDAT'.
                    CONCATENATE ls_editpos-f_new+6
                                ls_editpos-f_new(2)
                                ls_editpos-f_new+3(2)
                                INTO lv_date_from.
                  ENDIF.
                ELSE.
                  IF lv_date_until IS INITIAL AND
                     ls_editpos-fname = 'VENDDAT'.
                    CONCATENATE ls_editpos-f_old+6
                                ls_editpos-f_old(2)
                                ls_editpos-f_old+3(2)
                                INTO lv_date_until.
                  ELSEIF lv_date_from IS INITIAL AND
                     ls_editpos-fname = 'VBEGDAT'.
                    CONCATENATE ls_editpos-f_old+6
                                ls_editpos-f_old(2)
                                ls_editpos-f_old+3(2)
                                INTO lv_date_from.
                  ENDIF.
                ENDIF.

              ENDLOOP.
              IF lv_date_until IS NOT INITIAL OR
                 lv_date_from IS NOT INITIAL.
                IF lv_date_until IS INITIAL.
                  lv_date_until = ls_jksecontrindex-valid_until.
                ENDIF.
                IF lv_date_from IS INITIAL.
                  lv_date_from = ls_jksecontrindex-valid_from.
                ENDIF.

* Änderung am EndeDatum -> check agin validity with adjusted date
                PERFORM check_validity_contract USING    ls_vbegdat
                                                         ls_venddat
                                                         lv_date_from
                                                         lv_date_until  "adjusted end date
                                                         ls_jksenip-sub_valid_from
                                                         ls_jksenip-sub_valid_until
                                                CHANGING lv_valid.
                IF lv_valid = abap_false.
* Changedocument available, validity was changed, but still not valid
                  IF p_sum IS INITIAL.
                    WRITE: / 'Order exists, but not valid...e)', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
                  ENDIF.
                  lv_counter_order_exists =  lv_counter_order_exists + 1.
                  CONTINUE.
                ELSE.
* validity is ok after adjustment of the dates
                ENDIF.
              ELSE.
* Changedocument available, but didn't influence the validity
                IF p_sum IS INITIAL.
                  WRITE: / 'Order exists, but not valid...f)', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
                ENDIF.
                lv_counter_order_exists = lv_counter_order_exists + 1.
                CONTINUE.
              ENDIF.
            ENDIF.

          ELSE.
* generated order not found
            IF p_sum IS INITIAL.
              WRITE: / 'Order exists, but not valid...c)', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
            ENDIF.
            lv_counter_order_exists = lv_counter_order_exists + 1.
            CONTINUE.
          ENDIF.

        ELSE.
* no order found or more than one order found
          IF p_sum IS INITIAL.
            WRITE: / 'Order exists, but not valid... d)', <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
          ENDIF.
          lv_counter_order_exists = lv_counter_order_exists + 1.
          CONTINUE.
        ENDIF.
      ENDIF.

      IF lv_valid = abap_false.
        APPEND <fs_jksesched> TO lt_jksesched_del.
        lv_counter = lv_counter + 1.
        IF p_sum IS INITIAL.
          WRITE: / <fs_jksesched>-vbeln, <fs_jksesched>-posnr, <fs_jksesched>-issue, <fs_jksesched>-sequence.
        ENDIF.
      ENDIF.

    ENDLOOP.

    IF p_del = abap_true.
      lv_counter_del_table = lv_counter_del_table + lines( lt_jksesched_del ).
      DELETE jksesched FROM TABLE lt_jksesched_del.
      CALL FUNCTION 'DB_COMMIT'.      "holds the cursor
    ENDIF.
  ENDDO.

  SKIP 2.
  WRITE: 'Summary'.
  IF p_del = abap_true.
    WRITE: / 'Number of records deleted from database:', lv_counter_del_table.
  ENDIF.
  WRITE: / 'a) Not valid, can be deleted', lv_counter.
  WRITE: / 'b) JKSECONTRINDEX not available'.
  WRITE: / '   VBAP not available -> probaby deleted: ', lv_counter_vbap_missing.
  WRITE: / 'c) JKSECONTRINDEX not available'.
  WRITE: / '   VBAP available but AUART is no I-SM AUART (ism_contract<>02)', lv_counter_auart_noism_missing.
  WRITE: / 'd) JKSECONTRINDEX not available'.
  WRITE: / '   VBAP available but AUART is I-SM AUART (ism_contract= 02,TRVOG<>4)', lv_counter_auart_ism_missing.
  WRITE: / 'e) JKSECONTRINDEX not available'.
  WRITE: / '   VBAP available, check contract type:', lv_counter_auart_check.
  WRITE: / 'f) Not valid, but order exists, cannot be deleted', lv_counter_order_exists.
  WRITE: / 'g) Product changed, can be deleted', lv_counter_product_changed.




FORM check_validity_contract  USING    in_guebg           TYPE vbak-guebg   "kontrakt
                                       in_gueen           TYPE vbak-gueen   "kontrakt
                                       in_veda_date_from  TYPE sy-datum     "veda kontrakt
                                       in_veda_date_until TYPE sy-datum     "veda kontrakt
                                       in_valid_from      TYPE sy-datum     "nip
                                       in_valid_until     TYPE sy-datum     "nip
                              CHANGING out_valid          TYPE c.
  DATA: lv_valid_from      TYPE veda-vbegdat,
        lv_valid_until     TYPE veda-venddat,
        lv_guebg           TYPE vbak-guebg,
        lv_gueen           TYPE vbak-gueen,
        lv_veda_date_from  TYPE veda-venddat,
        lv_veda_date_until TYPE veda-vbegdat.


* Rückgabewerte initialisieren
  CLEAR out_valid.

* Wenn keine Einschränkung => okay.
  IF in_valid_from IS INITIAL AND
     in_valid_until IS INITIAL.
    out_valid = 'X'.
    EXIT.
  ENDIF.

* Übernahme der übergebenen Werte in lokale Variablen
  lv_valid_from      = in_valid_from.
  lv_valid_until     = in_valid_until.
  lv_guebg           = in_guebg.
  lv_gueen           = in_gueen.
  lv_veda_date_from  = in_veda_date_from.
  lv_veda_date_until = in_veda_date_until.

* Setze lv_valid_from um
  IF lv_valid_from IS INITIAL.
    lv_valid_from = '99991231'.
  ENDIF.
* Setze lv_gueen um
  IF lv_gueen IS INITIAL.
    lv_gueen = '99991231'.
  ENDIF.
* Setze lv_veda_date_until um
  IF lv_veda_date_until IS INITIAL.
    lv_veda_date_until = '99991231'.
  ENDIF.

* wenn alles initial ist dann ist Versandplan gültig
  IF in_veda_date_from IS INITIAL AND
     in_veda_date_until IS INITIAL AND
     in_guebg IS INITIAL AND
     in_gueen IS INITIAL.
    out_valid = 'X'.
    RETURN.
  ENDIF.

* 1. Vertragsdaten berücksichtigen
  IF in_veda_date_from IS NOT INITIAL AND
     in_veda_date_until IS NOT INITIAL.
    IF lv_veda_date_from <= lv_valid_until AND lv_veda_date_until >= lv_valid_from.
      out_valid = 'X'.
      RETURN.
    ELSE.
      CLEAR out_valid.
    ENDIF.
  ELSE.
* 2. Kontraktgültigkeit berücksichtigen
    IF in_guebg IS NOT INITIAL AND
       in_gueen IS NOT INITIAL.
      IF lv_guebg <= lv_valid_until AND lv_gueen >= lv_valid_from.
        out_valid = 'X'.
        RETURN.
      ELSE.
        CLEAR out_valid.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM check_product  USING is_jksenip TYPE jksenip
                          is_jksecontrindex TYPE jksecontrindex
                    CHANGING cv_product_ok TYPE abap_bool.

  DATA: product_range_tab    TYPE rjksd_issue_range_tab,
        assigned_product_tab TYPE STANDARD TABLE OF jpseprodcomp,
        assigned_product     TYPE jpseprodcomp,
        product              TYPE rjksdmatnr,
        tjseries             TYPE tjseries,
        tjseries_tab         TYPE STANDARD TABLE OF tjseries.

  cv_product_ok = abap_false.

  IF is_jksenip-product = is_jksecontrindex-matnr.
    cv_product_ok = abap_true.
    RETURN.
  ENDIF.

* Zugeordnete Produkte zum Produkt bestimmen
  CALL FUNCTION 'ISM_SD_MATERIAL_TO_RANGE'
    EXPORTING
      in_matnr  = is_jksecontrindex-matnr
    CHANGING
      range_tab = product_range_tab.
  CALL FUNCTION 'ISM_SE_GET_ASSIGNED_PRODUCTS'
    EXPORTING
      in_product_tab  = product_range_tab
    TABLES
      out_product_tab = assigned_product_tab.

  IF assigned_product_tab IS INITIAL.
* keine zugeordneten Produkte / Produkthierarchie
* cv_product_ok = abap_false. =>
* es dürfen keine JKSESCHED Sätze vorhanden sein
    RETURN.
  ENDIF.

  LOOP AT assigned_product_tab INTO assigned_product.
    IF is_jksenip-product = assigned_product-assignedproduct.
      product-matnr = assigned_product-assignedproduct.
* 3. Serieneigenschaft zu den Produkten bestimmen
      CALL FUNCTION 'ISM_SE_GET_SERIES'
        EXPORTING
          in_product   = product-matnr
        IMPORTING
          out_tjseries = tjseries.
      IF tjseries-deliveryplan IS NOT INITIAL.
* ok, the product in JKSESCHED is a assigned product in product hierarchy
* and itself delivery plan is used
        cv_product_ok = abap_true.
        RETURN.
      ENDIF.
    ENDIF.

  ENDLOOP.

ENDFORM.
