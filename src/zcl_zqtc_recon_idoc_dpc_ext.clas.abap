class ZCL_ZQTC_RECON_IDOC_DPC_EXT definition
  public
  inheriting from ZCL_ZQTC_RECON_IDOC_DPC
  create public .

public section.
protected section.

  methods IDOC_FIELDSSET_CREATE_ENTITY
    redefinition .
  methods IDOC_FIELDSSET_GET_ENTITY
    redefinition .
  methods IDOC_FIELDSSET_GET_ENTITYSET
    redefinition .
  methods IDOC_COUNTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZQTC_RECON_IDOC_DPC_EXT IMPLEMENTATION.


  METHOD idoc_countset_get_entityset.

*   Types declaration
    TYPES:
      BEGIN OF ty_output,
        devid       TYPE char10,
        description TYPE char120,
        stdate      TYPE char10,
        endate      TYPE char10,
        mestyp      TYPE char30,
        msgdesc     TYPE char120,
        rcvpor      TYPE char10,
        rcvprn      TYPE char10,
        sndpor      TYPE char10,
        sndprn      TYPE char10,
        mescod      TYPE char3,
        total       TYPE i,
        success     TYPE i,
        internal    TYPE i,
      END OF ty_output,
      BEGIN OF ty_output_det,
        docnum TYPE edi_docnum,
        status TYPE edi_status,
        rcvprn TYPE edi_rcvprn,
        mescod TYPE edi_mescod,
        mesfct TYPE edi_mesfct,
        stdate TYPE edi_ccrdat,
        mestyp TYPE edi_mestyp,
        idoctp TYPE edi_idoctp,
        cimtyp TYPE edi_cimtyp,
      END OF ty_output_det,
      BEGIN OF lty_edid4,
        docnum  TYPE edi_docnum, "IDoc number
        counter TYPE edi_clustc, "Counter in cluster table
        segnum  TYPE idocdsgnum, "Number of SAP segment
        segnam  TYPE edi_segnam, "Name of SAP segment
        dtint2  TYPE edi_dtint2, "Length field for VARC field
        sdata   TYPE edi_sdata,  "Application data
      END OF lty_edid4.
*   Local data declaration
    DATA:
***      li_edids   TYPE STANDARD TABLE OF edids, "table for edidd
      li_edidd        TYPE STANDARD TABLE OF edidd, "table for edidc
*      li_edid4   TYPE STANDARD TABLE OF ty_edid4, "table for edidc
      li_edid4        TYPE STANDARD TABLE OF lty_edid4,
*                     INITIAL SIZE 0,
***      lst_edids  TYPE edids,                   "edids structure.
*      li_edidc   TYPE STANDARD TABLE OF ty_output_det,
      lst_output      TYPE zcl_zqtc_recon_idoc_mpc=>ts_idoc_count,
      li_output       TYPE zcl_zqtc_recon_idoc_mpc=>tt_idoc_count,
      lst_zcaconstant TYPE STANDARD TABLE OF zcaconstant,
      lst_final       TYPE STANDARD TABLE OF ty_output,
      lwa_final       TYPE ty_output.

    DATA: lv_msg      TYPE bapi_msg, "message.
          lv_set      TYPE i,
          lv_idco     TYPE edidc-docnum,
          lv_ag       TYPE parvw,
          lv_44(03)   TYPE c,
          lv_stdate   TYPE erdat,
          lv_endate   TYPE erdat,
          lt_date     TYPE date_t_range,
          ls_date     TYPE date_range,
          lv_tabix    TYPE sytabix,
          lv_devid    TYPE zdevid,
          lv_total    TYPE i,
          lv_success  TYPE i,
          lv_internal TYPE i,
          lt_devrange TYPE RANGE OF zdevid,
          lt_devids   TYPE RANGE OF zdevid,
          lv_devrange LIKE LINE OF lt_devrange.
*  Constant declaration
    CONSTANTS: lc_ag    TYPE parvw VALUE 'AG',
               lc_we    TYPE parvw VALUE 'WE',
               lc_51    TYPE edidc-status VALUE '51',
               lc_53    TYPE edidc-status VALUE '53',
               lc_z10   TYPE edidc-mescod VALUE 'Z10',
               lc_44    TYPE edidc-mescod VALUE '044',
               lc_zsro  TYPE auart VALUE 'ZREW',
               lc_devid TYPE zdevid     VALUE 'RECON'.
    "Fetching Entries from Constant Table
    SELECT devid,
           param1,
           param2,
           srno,
           sign,
           opti,
           low,
           high,
           description
      FROM zcaconstant
      INTO TABLE @DATA(lt_constant)
     WHERE devid    EQ @lc_devid
       AND activate EQ @abap_true.

    IF sy-subrc IS INITIAL.

    ENDIF.


    LOOP AT lt_constant ASSIGNING  FIELD-SYMBOL(<ls_const>).

      lv_devrange-sign = 'I'.
      lv_devrange-option = 'EQ'.
      lv_devrange-low  = <ls_const>-param1.

      APPEND lv_devrange TO lt_devids.
      CLEAR lv_devrange.

    ENDLOOP.


    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Stdate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_stdate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Endate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_endate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Devid'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_devrange-sign = 'I'.
              lv_devrange-option = 'EQ'.
              lv_devrange-low  = <ls_filter_opt>-low.
              APPEND lv_devrange TO lt_devrange.
              CLEAR lv_devrange.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    IF lt_devrange IS INITIAL.

      LOOP AT lt_constant
        INTO DATA(lv_constant).
        lv_devrange-sign = 'I'.
        lv_devrange-option = 'EQ'.
        lv_devrange-low  = lv_constant-param1.
        APPEND lv_devrange TO lt_devrange.
        CLEAR lv_devrange.
      ENDLOOP.
    ENDIF.

*    lv_stdate = ( sy-datum - 90 ).
*    lv_endate = sy-datum.
    lv_stdate = '20200101'.
    lv_endate = sy-datum.
    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
*      ls_date-low = lv_stdate.
      ls_date-low = '20200101'.
      ls_date-high = lv_endate.
      ls_date-option = 'BT'.
      ls_date-sign = 'I'.
      APPEND ls_date TO lt_date.
    ENDIF.

    SELECT docnum, status,rcvpor, rcvprn, mescod, mesfct,sndpor,sndprn,credat,mestyp,idoctp,cimtyp
        FROM edidc
        INTO TABLE @DATA(li_edidc)
        WHERE credat IN @lt_date
          AND ( status = @lc_51 OR status = @lc_53 ).
*          AND mescod = @lc_z10." = '0000000001710339'."idoc_number."ls_key_tab-value.
    IF sy-subrc = 0.
      IF li_edidc[] IS NOT INITIAL.
*   Fetch data from Idoc segment
        SELECT docnum counter segnum segnam dtint2 sdata
          FROM edid4
          INTO TABLE li_edid4
          FOR ALL ENTRIES IN li_edidc
          WHERE docnum = li_edidc-docnum.
      ENDIF.

      SELECT docnum,logdat,logtim,countr,status,stapa1,stapa2,stamid,stamno
        FROM edids
        INTO TABLE @DATA(li_edids)
        FOR ALL ENTRIES IN @li_edidc
        WHERE docnum = @li_edidc-docnum.
      IF sy-subrc EQ 0.
        SORT li_edids BY docnum logdat countr DESCENDING.

      ENDIF.
      SORT li_edidc BY mescod.
      SORT li_edid4 BY docnum.
      CLEAR: lv_total,lv_success, lv_internal.

* If filteration initiated from front end/UI5
      IF lt_devrange[] IS  INITIAL AND lt_devids[] IS NOT INITIAL.
        lt_devrange[] = lt_devids[].
      ENDIF.

      LOOP AT lt_devrange
        INTO lv_devrange.

        CLEAR: lv_total, lv_success, lv_internal.

        READ TABLE lt_constant
          INTO DATA(lwa_constant)
          WITH KEY  param1 = lv_devrange-low.

        IF  sy-subrc  IS INITIAL.

          READ TABLE li_edidc
            ASSIGNING FIELD-SYMBOL(<ls_edidc>)
            WITH KEY mescod = lwa_constant-param2 BINARY SEARCH.
          IF  sy-subrc IS INITIAL
          AND <ls_edidc> IS ASSIGNED.
            lv_tabix = sy-tabix.

            LOOP AT li_edidc
              ASSIGNING <ls_edidc>
              FROM lv_tabix.
              IF <ls_edidc>-mescod NE lwa_constant-param2.
                EXIT.
              ELSE.
                ADD 1 TO lv_total.
                IF <ls_edidc>-status EQ '51'.
                  ADD 1 TO lv_internal.
                ELSEIF <ls_edidc>-status EQ '53'.
                  ADD 1 TO lv_success.
                ENDIF.
*                AT NEW mescod.
                lwa_final-devid = lv_devrange-low.
                lwa_final-description = lwa_constant-description.
                lwa_final-total = lv_total.
                lwa_final-internal = lv_internal.
                lwa_final-success = lv_success.
                lwa_final-stdate = lv_stdate.
                lwa_final-endate = lv_endate.
*                lwa_final-mestyp = <ls_edidc>-mestyp.
                lwa_final-rcvpor = <ls_edidc>-rcvpor.
*                lwa_final-rcvprn = <ls_edidc>-rcvprn.
                lwa_final-sndpor = <ls_edidc>-sndpor.
*                lwa_final-sndprn = <ls_edidc>-sndprn.
                lwa_final-mescod = <ls_edidc>-mescod.
*                    APPEND lst_output TO et_entityset.
                COLLECT lwa_final INTO lst_final.
                CLEAR: lwa_final.
*                ENDAT.
              ENDIF.
            ENDLOOP.
          ELSEIF <ls_edidc> IS NOT ASSIGNED.

          ENDIF.
        ENDIF.

      ENDLOOP.
      SORT lst_final BY devid.
      DELETE ADJACENT DUPLICATES FROM lst_final COMPARING devid.
      LOOP AT lst_final
        INTO  lwa_final.
        lst_output-devid       = lwa_final-devid.
        lst_output-description = lwa_final-description.
        lst_output-total       = lwa_final-total.
        lst_output-internal    = lwa_final-internal.
        lst_output-success     = lwa_final-success.
        lst_output-stdate      = lwa_final-stdate.
        lst_output-endate      = lwa_final-endate .
        lst_output-mestyp      = lwa_final-mestyp.
        lst_output-rcvpor      = lwa_final-rcvpor .
        lst_output-rcvprn      = lwa_final-rcvprn.
        lst_output-sndpor      = lwa_final-sndpor.
        lst_output-sndprn      = lwa_final-sndprn.
        lst_output-mescod      = lwa_final-mescod.
        APPEND lst_output TO et_entityset.
        CLEAR lst_output.
      ENDLOOP.

*      LOOP AT li_edidc ASSIGNING FIELD-SYMBOL(<ls_edidc>).
*        lst_output-devid = lv_devid.
*        READ TABLE lt_constant
*          INTO DATA(lwa_constant)
*          WITH KEY  param1 = lst_output-devid.
*        IF  sy-subrc            IS INITIAL
*        AND lwa_constant-param2 EQ <ls_edidc>-mescod.
*
*
*        ENDIF.
**        READ TABLE li_edid4 WITH KEY docnum = <ls_edidc>-docnum TRANSPORTING NO FIELDS BINARY SEARCH.
**        IF sy-subrc = 0.
**          lv_tabix = sy-tabix.
**          LOOP AT li_edid4 INTO DATA(ls_edid4) FROM lv_tabix.
**            IF ls_edid4-docnum <> <ls_edidc>-docnum.
**              EXIT.
**            ENDIF.
*            lst_output-docnum = <ls_edidc>-docnum.                  "Idoc Number
*            lst_output-stdate = lv_stdate.
*            lst_output-endate = lv_endate.
*            lst_output-status = <ls_edidc>-status.
*            lst_output-mestyp = <ls_edidc>-mestyp.                           "Message
*            lst_output-rcvpor = <ls_edidc>-rcvpor.
*            lst_output-rcvprn = <ls_edidc>-rcvprn.
*            lst_output-sndpor = <ls_edidc>-sndpor.
*            lst_output-sndprn = <ls_edidc>-sndprn.
*            lst_output-mescod = <ls_edidc>-mescod.                  "Message Variant
*            lst_output-mesfct = <ls_edidc>-mesfct.                 "Message function
*            lst_output-idoctp = <ls_edidc>-idoctp.                   "Basic type
*            lst_output-cimtyp = <ls_edidc>-cimtyp.                    "Extension
*            CASE ls_edid4-segnam.
*              WHEN 'E1EDK01'.
*              WHEN 'E1EDK14'.
*              WHEN 'E1EDK03'.
*              WHEN 'E1EDK05'.
*              WHEN 'E1EDKA1'.
*                lv_set = strlen( ls_edid4-sdata ).
*                lv_ag = ls_edid4-sdata+0(lv_set).
*                IF lv_ag EQ lc_ag.
*                  lst_output-agpartner = ls_edid4-sdata+3(lv_set).
**                  SUBTRACT 10 FROM lv_set.
**                  lst_output-ag_partner = ls_edid4-sdata+lv_set(10).
*                ELSEIF lv_ag EQ lc_we.
*                  lst_output-wepartner = ls_edid4-sdata+3(lv_set).
**                  SUBTRACT 10 FROM lv_set.
**                  lst_output-ag_partner = ls_edid4-sdata+lv_set(10).
*                ENDIF.
*              WHEN 'E1EDP02'.
*                lv_set = strlen( ls_edid4-sdata ).
*                lv_44  = ls_edid4-sdata+0(lv_set).
*                IF lv_44 EQ lc_44.
*                  lst_output-qualf = lv_44.
*                  CONDENSE ls_edid4-sdata NO-GAPS.
*                  lst_output-belnr = ls_edid4-sdata+3(lv_set).
*                ENDIF.
*
*              WHEN OTHERS.
*            ENDCASE.
*            READ TABLE li_edids INTO DATA(lst_edids) WITH KEY docnum = <ls_edidc>-docnum
*                                                              status = <ls_edidc>-status.
*            IF sy-subrc = 0.
*              CALL FUNCTION 'FORMAT_MESSAGE'
*                EXPORTING
*                  id        = lst_edids-stamid
*                  lang      = sy-langu
*                  no        = lst_edids-stamno
*                  v1        = lst_edids-stapa1
*                  v2        = lst_edids-stapa2
**                 v3        = lst_edids-stapa3
**                 v4        = lst_edids-stapa4
*                IMPORTING
*                  msg       = lv_msg
*                EXCEPTIONS
*                  not_found = 1
*                  OTHERS    = 2.
*              lst_output-msgdesc = lv_msg.
*            ENDIF.
*            APPEND lst_output TO et_entityset.
*            CLEAR: lst_output.
**          ENDLOOP.
**          CLEAR lv_tabix.
**        ENDIF.
*      ENDLOOP.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid  = /iwbep/cx_mgw_busi_exception=>business_error
          message = 'Idoc Number Not Found For Segment IDOC_FIELDS'.
    ENDIF.
    "
    "
****      lst_output-Belnr  = lst_edids-status.                 "Referance Doc
****      lst_output-Posnr  = lst_edids-status.                 "Referance Doc Item
*  ENDIF.

  ENDMETHOD.


  METHOD idoc_fieldsset_create_entity.
**TRY.
*CALL METHOD SUPER->IDOC_FIELDSSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    ENDMETHOD.


  METHOD idoc_fieldsset_get_entity.
**TRY.
*CALL METHOD SUPER->IDOC_FIELDSSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD idoc_fieldsset_get_entityset.
*   Types declaration
    TYPES:
      BEGIN OF ty_output_det,
        docnum TYPE edi_docnum,
        status TYPE edi_status,
        rcvprn TYPE edi_rcvprn,
        mescod TYPE edi_mescod,
        mesfct TYPE edi_mesfct,
        stdate TYPE edi_ccrdat,
        mestyp TYPE edi_mestyp,
        idoctp TYPE edi_idoctp,
        cimtyp TYPE edi_cimtyp,
      END OF ty_output_det,
      BEGIN OF lty_edid4,
        docnum  TYPE edi_docnum, "IDoc number
        counter TYPE edi_clustc, "Counter in cluster table
        segnum  TYPE idocdsgnum, "Number of SAP segment
        segnam  TYPE edi_segnam, "Name of SAP segment
        dtint2  TYPE edi_dtint2, "Length field for VARC field
        sdata   TYPE edi_sdata,  "Application data
      END OF lty_edid4.
*   Local data declaration
    DATA:
***      li_edids   TYPE STANDARD TABLE OF edids, "table for edidd
      li_edidd   TYPE STANDARD TABLE OF edidd, "table for edidc
*      li_edid4   TYPE STANDARD TABLE OF ty_edid4, "table for edidc
      li_edid4   TYPE STANDARD TABLE OF lty_edid4,
*                     INITIAL SIZE 0,
***      lst_edids  TYPE edids,                   "edids structure.
*      li_edidc   TYPE STANDARD TABLE OF ty_output_det,
      lst_output TYPE zcl_zqtc_recon_idoc_mpc=>ts_idoc_fields,
      li_output  TYPE zcl_zqtc_recon_idoc_mpc=>tt_idoc_fields,
      lst_zcaconstant TYPE STANDARD TABLE OF zcaconstant.

    DATA: lv_msg    TYPE bapi_msg, "message.
          lv_set    TYPE i,
          lv_idco   TYPE edidc-docnum,
          lv_ag     TYPE parvw,
          lv_44(03) TYPE c,
          lv_stdate TYPE erdat,
          lv_endate TYPE erdat,
          lt_date   TYPE date_t_range,
          ls_date   TYPE date_range,
          lv_tabix  TYPE sytabix,
          lv_devid  TYPE zdevid.
*  Constant declaration
    CONSTANTS: lc_ag   TYPE parvw VALUE 'AG',
               lc_we   TYPE parvw VALUE 'WE',
               lc_51   TYPE edidc-status VALUE '51',
               lc_z10  TYPE edidc-mescod VALUE 'Z10',
               lc_44   TYPE edidc-mescod VALUE '044',
               lc_zsro TYPE auart VALUE 'ZREW',
               gc_devid   TYPE zdevid     VALUE 'RECON'.
  "Fetching Entries from Constant Table
    SELECT devid,
           param1,
           param2,
           srno,
           sign,
           opti,
           low
      FROM zcaconstant
      INTO TABLE @DATA(lt_constant)
     WHERE devid    EQ @gc_devid
       AND activate EQ @abap_true.

    IF sy-subrc IS INITIAL.

    ENDIF.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>).
      LOOP AT <ls_filter>-select_options ASSIGNING  FIELD-SYMBOL(<ls_filter_opt>).
        CASE <ls_filter>-property.
          WHEN 'Stdate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_stdate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Endate'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_endate = <ls_filter_opt>-low+0(4) &&
              <ls_filter_opt>-low+5(2) && <ls_filter_opt>-low+8(2) .
            ENDIF.
          WHEN 'Devid'.
            IF <ls_filter_opt>-low IS NOT INITIAL.
              lv_devid = <ls_filter_opt>-low.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    lv_stdate = ( sy-datum - 90 ).
    lv_endate = sy-datum.

    IF lv_stdate IS NOT INITIAL AND lv_endate IS NOT INITIAL.
      ls_date-low = lv_stdate.
      ls_date-high = lv_endate.
      ls_date-option = 'BT'.
      ls_date-sign = 'I'.
      APPEND ls_date TO lt_date.
    ENDIF.

    SELECT docnum, status,rcvpor, rcvprn, mescod, mesfct,sndpor,sndprn,credat,mestyp,idoctp,cimtyp
        FROM edidc
        INTO TABLE @DATA(li_edidc)
        WHERE credat IN @lt_date
          AND status = @lc_51
          AND mescod = @lc_z10." = '0000000001710339'."idoc_number."ls_key_tab-value.
    IF sy-subrc = 0.
      IF li_edidc[] IS NOT INITIAL.
*   Fetch data from Idoc segment
        SELECT docnum counter segnum segnam dtint2 sdata
          FROM edid4
          INTO TABLE li_edid4
          FOR ALL ENTRIES IN li_edidc
          WHERE docnum = li_edidc-docnum.
      ENDIF.

      SELECT docnum,logdat,logtim,countr,status,stapa1,stapa2,stamid,stamno
        FROM edids
        INTO TABLE @DATA(li_edids)
        FOR ALL ENTRIES IN @li_edidc
        WHERE docnum = @li_edidc-docnum.
      IF sy-subrc EQ 0.
        SORT li_edids BY docnum logdat countr DESCENDING.

      ENDIF.
      SORT li_edidc BY docnum.
      SORT li_edid4 BY docnum.
      LOOP AT li_edidc ASSIGNING FIELD-SYMBOL(<ls_edidc>).
        lst_output-devid = lv_devid.
        READ TABLE lt_constant
          INTO DATA(lwa_constant)
          WITH KEY  param1 = lst_output-devid.
        IF  sy-subrc            IS INITIAL
        AND lwa_constant-param2 EQ <ls_edidc>-mescod.


        ENDIF.
        READ TABLE li_edid4 WITH KEY docnum = <ls_edidc>-docnum TRANSPORTING NO FIELDS BINARY SEARCH.
        IF sy-subrc = 0.
          lv_tabix = sy-tabix.
          LOOP AT li_edid4 INTO DATA(ls_edid4) FROM lv_tabix.
            IF ls_edid4-docnum <> <ls_edidc>-docnum.
              EXIT.
            ENDIF.
            lst_output-docnum = <ls_edidc>-docnum.                  "Idoc Number
            lst_output-stdate = lv_stdate.
            lst_output-endate = lv_endate.
            lst_output-status = <ls_edidc>-status.
            lst_output-mestyp = <ls_edidc>-mestyp.                           "Message
            lst_output-rcvpor = <ls_edidc>-rcvpor.
            lst_output-rcvprn = <ls_edidc>-rcvprn.
            lst_output-sndpor = <ls_edidc>-sndpor.
            lst_output-sndprn = <ls_edidc>-sndprn.
            lst_output-mescod = <ls_edidc>-mescod.                  "Message Variant
            lst_output-mesfct = <ls_edidc>-mesfct.                 "Message function
            lst_output-idoctp = <ls_edidc>-idoctp.                   "Basic type
            lst_output-cimtyp = <ls_edidc>-cimtyp.                    "Extension
            CASE ls_edid4-segnam.
              WHEN 'E1EDK01'.
              WHEN 'E1EDK14'.
              WHEN 'E1EDK03'.
              WHEN 'E1EDK05'.
              WHEN 'E1EDKA1'.
                lv_set = strlen( ls_edid4-sdata ).
                lv_ag = ls_edid4-sdata+0(lv_set).
                IF lv_ag EQ lc_ag.
                  lst_output-agpartner = ls_edid4-sdata+3(lv_set).
*                  SUBTRACT 10 FROM lv_set.
*                  lst_output-ag_partner = ls_edid4-sdata+lv_set(10).
                ELSEIF lv_ag EQ lc_we.
                  lst_output-wepartner = ls_edid4-sdata+3(lv_set).
*                  SUBTRACT 10 FROM lv_set.
*                  lst_output-ag_partner = ls_edid4-sdata+lv_set(10).
                ENDIF.
              WHEN 'E1EDP02'.
                lv_set = strlen( ls_edid4-sdata ).
                lv_44  = ls_edid4-sdata+0(lv_set).
                IF lv_44 EQ lc_44.
                  lst_output-qualf = lv_44.
                  CONDENSE ls_edid4-sdata NO-GAPS.
                  lst_output-belnr = ls_edid4-sdata+3(lv_set).
                ENDIF.

              WHEN OTHERS.
            ENDCASE.
            READ TABLE li_edids INTO DATA(lst_edids) WITH KEY docnum = <ls_edidc>-docnum
                                                              status = <ls_edidc>-status.
            IF sy-subrc = 0.
              CALL FUNCTION 'FORMAT_MESSAGE'
                EXPORTING
                  id        = lst_edids-stamid
                  lang      = sy-langu
                  no        = lst_edids-stamno
                  v1        = lst_edids-stapa1
                  v2        = lst_edids-stapa2
*                 v3        = lst_edids-stapa3
*                 v4        = lst_edids-stapa4
                IMPORTING
                  msg       = lv_msg
                EXCEPTIONS
                  not_found = 1
                  OTHERS    = 2.
              lst_output-msgdesc = lv_msg.
            ENDIF.
            APPEND lst_output TO et_entityset.
            CLEAR: lst_output,lst_edids.
          ENDLOOP.
          CLEAR lv_tabix.
        ENDIF.
      ENDLOOP.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid  = /iwbep/cx_mgw_busi_exception=>business_error
          message = 'Idoc Number Not Found For Segment IDOC_FIELDS'.
    ENDIF.
    "
    "
****      lst_output-Belnr  = lst_edids-status.                 "Referance Doc
****      lst_output-Posnr  = lst_edids-status.                 "Referance Doc Item
*  ENDIF.

  ENDMETHOD.
ENDCLASS.
