*----------------------------------------------------------------------*
***INCLUDE LZQTC_LOISTDF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
  DATA:lst_object TYPE rsocdobjectcl.

  SELECT devid,      " Development ID
         param1,     " ABAP: Name of Variant Variable
         param2,     " ABAP: Name of Variant Variable
         srno,       " ABAP: Current selection number
         sign,       " ABAP: ID: I/E (include/exclude values)
         opti,       " ABAP: Selection option (EQ/BT/CP/...)
         low,        " Lower Value of Selection Condition
         high       " Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @DATA(li_constants)
    WHERE devid    = @c_devid
      AND activate = @abap_true.
  IF sy-subrc EQ 0.
    SORT li_constants BY devid param1 param2 srno.
  ENDIF.
  LOOP AT li_constants INTO DATA(lst_constants).
    CASE lst_constants-param1.
      WHEN c_object.
*---Object
        lst_object-sign   = lst_constants-sign.
        lst_object-option = lst_constants-opti.
        lst_object-low    = lst_constants-low.
        lst_object-high   = lst_constants-high.
        APPEND lst_object TO ir_object.
        CLEAR lst_object.
      WHEN c_table.
        ir_table-sign   = lst_constants-sign.
        ir_table-option = lst_constants-opti.
        ir_table-low    = lst_constants-low.
        ir_table-high   = lst_constants-high.
        APPEND ir_table TO ir_table[].
        CLEAR ir_table.
      WHEN c_fname.
        ir_fname-sign   = lst_constants-sign.
        ir_fname-option = lst_constants-opti.
        ir_fname-low    = lst_constants-low.
        ir_fname-high   = lst_constants-high.
        APPEND ir_fname TO ir_fname[].
        CLEAR ir_fname.
      WHEN c_werks.
        st_werks-sign   = lst_constants-sign.
        st_werks-option = lst_constants-opti.
        st_werks-low    = lst_constants-low.
        APPEND st_werks TO ir_werks[].
        CLEAR st_werks.
      WHEN c_target.
        iv_target  = lst_constants-low.
      WHEN c_mtart.
        CLEAR ir_mtart.
        ir_mtart-sign   = lst_constants-sign.
        ir_mtart-option = lst_constants-opti.
        ir_mtart-low    = lst_constants-low.
        APPEND ir_mtart TO ir_mtart[].
        CLEAR ir_mtart.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CHANGE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_change_log .
*----IV_DATE is the Last run date and This coming from ZCACONSTANT Table
*----IV_TIME is the Last run Time and This coming from ZCACONSTANT Table
*---once the CDHR select query executed then captured the system dat/Time to following fields Iv_date_last and iv_time_last
*---update these fields iv_date_last,iv_time_last to ZCACONTANT, once the IDOC is genarated success or failure
  IF iv_date IS NOT INITIAL.
    SELECT *
      FROM cdhdr
      INTO TABLE i_cdhdr
      WHERE objectclas IN ir_object
        AND ( ( udate > iv_date AND udate < sy-datum )
        OR   ( udate = iv_date AND udate < sy-datum AND utime >= iv_time )
        OR  ( udate = sy-datum AND  udate > iv_date AND utime < sy-uzeit )
        OR  ( udate = iv_date AND udate = sy-datum AND utime >= iv_time AND utime <= sy-uzeit ) ) .
    FREE:iv_date_last,iv_time_last.
    iv_date_last = sy-datum. "capturing the current run date
    iv_time_last = sy-uzeit. "capturing the current run time

    IF i_cdhdr IS NOT INITIAL.
      SELECT *
        FROM cdpos
        INTO TABLE i_cdpos
        FOR ALL ENTRIES IN i_cdhdr
        WHERE objectclas IN ir_object
          AND changenr = i_cdhdr-changenr
          AND tabname IN ir_table
          AND fname   IN ir_fname.
    ENDIF.
  ENDIF. " IF iv_date IS NOT INITIAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EBAN_FROM_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_eban_from_material .
  CONSTANTS:lc_eban TYPE tabname VALUE 'EBAN'.
  DATA(li_cdpos) = i_cdpos.
  SORT li_cdpos BY tabname.
  DELETE li_cdpos WHERE tabname <> lc_eban.
  IF li_cdpos IS NOT INITIAL.
    SELECT matnr
      FROM eban
      INTO TABLE i_matnr
      FOR ALL ENTRIES IN li_cdpos
      WHERE banfn = li_cdpos-objectid+0(10).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EKPO_FROM_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_ekpo_from_material.
  CONSTANTS:lc_ekpo TYPE tabname VALUE 'EKPO',
            lc_eket TYPE tabname VALUE 'EKET'.
  FREE:ir_table.
  ir_table-sign   = c_i.
  ir_table-option = c_eq.
  ir_table-low    = lc_ekpo.
  APPEND ir_table TO ir_table[].
  ir_table-low    = lc_eket.
  APPEND ir_table TO ir_table[].
  CLEAR ir_table.
  DATA(li_cdpos) = i_cdpos.
  SORT li_cdpos BY tabname.
  DELETE li_cdpos WHERE tabname NOT IN ir_table[].
  IF li_cdpos IS NOT INITIAL.
    SELECT matnr
        FROM ekpo
        APPENDING TABLE i_matnr
        FOR ALL ENTRIES IN li_cdpos
        WHERE ebeln = li_cdpos-objectid+0(10).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_VBAP_FROM_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_vbap_from_material .
  CONSTANTS:lc_vbap TYPE tabname VALUE 'VBAP',
            lc_vbep TYPE tabname VALUE 'VBEP'.
  FREE:ir_table.
  ir_table-sign   = c_i.
  ir_table-option = c_eq.
  ir_table-low    = lc_vbap.
  APPEND ir_table TO ir_table[].
  ir_table-low    = lc_vbep.
  APPEND ir_table TO ir_table[].
  CLEAR ir_table.
  DATA(li_cdpos) = i_cdpos.
  SORT li_cdpos BY tabname.
  DELETE li_cdpos WHERE tabname NOT IN ir_table[].
  IF li_cdpos IS NOT INITIAL.
    SELECT matnr
        FROM vbap
        APPENDING TABLE i_matnr
        FOR ALL ENTRIES IN li_cdpos
        WHERE vbeln = li_cdpos-objectid+0(10).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARC_FROM_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_marc_from_material .
  CONSTANTS:lc_marc TYPE tabname VALUE 'MARC'.
  DATA:lst_matnr TYPE ty_matnr.
  LOOP AT i_cdpos INTO DATA(lst_cdpos) WHERE tabname = lc_marc.
    lst_matnr-matnr = lst_cdpos-objectid+0(18).
    APPEND lst_matnr TO i_matnr.
    CLEAR lst_matnr.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RANGE_TABLE_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_range_table_material .
  SORT i_matnr BY matnr.
  DELETE ADJACENT DUPLICATES FROM i_matnr COMPARING matnr.
*---Material type restriction (only trigger - ZFRT)
  IF i_matnr IS NOT INITIAL.
    SELECT matnr
      FROM mara
      INTO TABLE @DATA(li_matnr)
      FOR ALL ENTRIES IN @i_matnr
      WHERE matnr = @i_matnr-matnr
        AND mtart IN @ir_mtart.
  ENDIF.
  LOOP AT li_matnr INTO DATA(lst_matnr).
    ir_matnr-sign   = c_i.
    ir_matnr-option = c_eq.
    ir_matnr-low    = lst_matnr-matnr.
    APPEND ir_matnr TO ir_matnr[].
    CLEAR ir_matnr.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SUBMIT_IDOC_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_submit_sel_to_idoc_create.

  DATA:lv_plscn    TYPE plsc-plscn,
       lr_dispo_st TYPE RANGE OF marc-dispo,
       lv_date_to  TYPE aaatdat,
       lv_date_fr  TYPE aaafdat.
*---for Delta Run IDOCS Creation
  IF ir_matnr[] IS NOT INITIAL
    AND ir_werks[] IS NOT INITIAL.
    SUBMIT rmcpamrp WITH opt_sys  EQ iv_target
                    WITH mestyp   EQ iv_msgtyp
                    WITH plscn    EQ lv_plscn
                    WITH dispo_st IN lr_dispo_st
                    WITH matnr_st IN ir_matnr
                    WITH werks_st IN ir_werks
                    WITH date_fr  EQ lv_date_fr
                    WITH date_to  EQ lv_date_to AND RETURN.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FREE_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_free_all .
  FREE:ir_object,
       iv_date,
       iv_time,
       iv_target,
       iv_msgtyp,
       ir_table,
       ir_fname,
       i_cdhdr,
       i_cdpos,
       i_matnr,
       ir_werks,
       st_werks,
       ir_matnr.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LIPS_FROM_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_lips_from_material .
  CONSTANTS:lc_lips TYPE tabname VALUE 'LIPS'.

  FREE:ir_table.
  ir_table-sign   = c_i.
  ir_table-option = c_eq.
  ir_table-low    = lc_lips.
  APPEND ir_table TO ir_table[].
  CLEAR ir_table.
  DATA(li_cdpos) = i_cdpos.
  SORT li_cdpos BY tabname.
  DELETE li_cdpos WHERE tabname NOT IN ir_table[].
  IF li_cdpos IS NOT INITIAL.
    SELECT matnr
        FROM lips
        APPENDING TABLE i_matnr
        FOR ALL ENTRIES IN li_cdpos
        WHERE vbeln = li_cdpos-objectid+0(10).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LAST_DATE_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_last_date_time .
  FREE:st_interface,iv_date,iv_time.
  SELECT SINGLE *
           FROM zcainterface "Interface run details
           INTO st_interface
          WHERE devid  = c_devid.
  IF sy-subrc = 0.
    iv_date = st_interface-lrdat.   "last run date
    iv_time = st_interface-lrtime.  "last run time
  ENDIF.
ENDFORM.
