*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_EXCEL_GENARATE_SUB_R112 (Include Program)
* PROGRAM DESCRIPTION: add additional filteration from the layout selection
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   06/09/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918448
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------**

TYPES : BEGIN OF ty_dbfilter,                                         " DB filter range declaration
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE char30,
          high TYPE char30,
        END OF ty_dbfilter.

TYPES : BEGIN OF ty_msgid,                                            " Messege ID range declaration
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE jsymsgidprotocol,
          high TYPE jsymsgidprotocol,
        END OF ty_msgid.

TYPES : BEGIN OF ty_msgnum,                                           " Messege Number
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE jmsgnoprotocol,
          high TYPE jmsgnoprotocol,
        END OF ty_msgnum.

DATA : lst_varkey    TYPE ltdxkey,
       li_dbfiledcat TYPE TABLE OF ltdxdata,
       li_dbsort     TYPE TABLE OF ltdxdata,
       li_dbfilter   TYPE TABLE OF ltdxdata,
       lv_index_db   TYPE sy-tabix,
       lv_msgid_nf   TYPE char1,
       lv_msgnum_nf  TYPE char1,
       lv_err_sub    TYPE netwr,
       lv_inf_sub    TYPE netwr,
       lv_total      TYPE netwr.


DATA: li_filter  TYPE STANDARD TABLE OF ty_dbfilter INITIAL SIZE 0,
      lst_filter TYPE ty_dbfilter,
      li_msgid_1 TYPE STANDARD TABLE OF ty_msgid INITIAL SIZE 0,
      li_msgnum  TYPE STANDARD TABLE OF ty_msgnum INITIAL SIZE 0,
      li_bg_tmp  TYPE STANDARD TABLE OF t_detail  INITIAL SIZE 0.

FIELD-SYMBOLS : <lfs_msgid>  TYPE ty_msgid,
                <lfs_msgnum> TYPE ty_msgnum.

CONSTANTS : lc_rel_type TYPE rvari_vnam  VALUE 'REL_FIELD',
            lc_msgid_1  TYPE char30 VALUE 'MSGID',
            lc_msgnum   TYPE char30 VALUE 'MSGNO',
            lc_msgty_i  TYPE msgty VALUE 'I',
            lc_msgty_e  TYPE msgty VALUE 'E',
            lc_report   TYPE rvari_vnam  VALUE 'REPORT',
            lc_variant  TYPE rvari_vnam  VALUE 'VARIANT',
            lc_type     TYPE rvari_vnam  VALUE 'TYPE'.

LOOP AT li_constant ASSIGNING <lfs_constant>.
  CASE <lfs_constant>-param1.
    WHEN lc_rel_type.                                       " Check lelavant fields
      lst_filter-sign = <lfs_constant>-sign.
      lst_filter-opti = <lfs_constant>-opti.
      lst_filter-low  = <lfs_constant>-low.
      lst_filter-high = <lfs_constant>-high.
      APPEND lst_filter TO li_filter.
      CLEAR lst_filter.
  ENDCASE.
ENDLOOP.

" Get report name
READ TABLE li_constant ASSIGNING <lfs_constant> WITH KEY param1 = lc_report BINARY SEARCH.
IF sy-subrc = 0.
  lst_varkey-report = <lfs_constant>-low.
ENDIF.
" Get variant name
READ TABLE li_constant ASSIGNING <lfs_constant> WITH KEY param1 = lc_variant BINARY SEARCH.
IF sy-subrc = 0.
  lst_varkey-variant = <lfs_constant>-low.
ENDIF.
" Get type name
READ TABLE li_constant ASSIGNING <lfs_constant> WITH KEY param1 = lc_type BINARY SEARCH.
IF sy-subrc = 0.
  lst_varkey-type = <lfs_constant>-low.
ENDIF.

" get layout details using the program and variant name
REFRESH : li_dbfiledcat , li_dbsort , li_dbfilter,
          li_msgid_1 , li_msgnum , i_subtotal.

CALL FUNCTION 'LT_DBDATA_READ_FROM_LTDX'
  EXPORTING
    i_tool       = 'LT'
    is_varkey    = lst_varkey
  TABLES
    t_dbfieldcat = li_dbfiledcat
    t_dbsortinfo = li_dbsort
    t_dbfilter   = li_dbfilter
**   T_DBLAYOUT   =
  EXCEPTIONS
    not_found    = 1
    wrong_relid  = 2
    OTHERS       = 3.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

" delete non relevant values for range variable from DBfilter itab
DELETE li_dbfilter WHERE param NOT IN li_filter.

" Separate all the filters into specific tables
LOOP AT li_dbfilter ASSIGNING FIELD-SYMBOL(<lfs_dbfilter>).
  CASE <lfs_dbfilter>-key1.
    WHEN lc_msgid_1.                  " Messege ID
      AT NEW key3.
        CLEAR lv_index_db.
        lv_index_db = lv_index_db + 1.
        APPEND INITIAL LINE TO li_msgid_1 ASSIGNING <lfs_msgid>.
        <lfs_msgid>-low = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgid>-low NO-GAPS.
        CONTINUE.
      ENDAT.
      IF lv_index_db = 1.         " High value
        <lfs_msgid>-high = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgid>-high NO-GAPS.
      ENDIF.
      IF lv_index_db = 2.         " Option
        <lfs_msgid>-opti = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgid>-opti NO-GAPS.
      ENDIF.
      IF lv_index_db = 3.         " Sign
        <lfs_msgid>-sign = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgid>-opti NO-GAPS.
      ENDIF.
    WHEN lc_msgnum.                   " Messege Number
      AT NEW key3.
        CLEAR lv_index_db.
        lv_index_db = lv_index_db + 1.
        APPEND INITIAL LINE TO li_msgnum ASSIGNING <lfs_msgnum>.
        <lfs_msgnum>-low = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgid>-low NO-GAPS.
        CONTINUE.
      ENDAT.
      IF lv_index_db = 1.         " High value
        <lfs_msgnum>-high = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgnum>-high NO-GAPS.
      ENDIF.
      IF lv_index_db = 2.         " Option
        <lfs_msgnum>-opti = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgnum>-opti NO-GAPS.
      ENDIF.
      IF lv_index_db = 3.         " Sign
        <lfs_msgnum>-sign = <lfs_dbfilter>-value.
        CONDENSE <lfs_msgnum>-opti NO-GAPS.
      ENDIF.
  ENDCASE.
  lv_index_db = lv_index_db + 1.

ENDLOOP.


LOOP AT li_bg_detail ASSIGNING FIELD-SYMBOL(<lfs_rm_details>).

  CLEAR : lv_msgid_nf , lv_msgnum_nf.

  IF <lfs_rm_details>-msgid IN li_msgid_1.      " Messege ID
    lv_msgid_nf = abap_false.
  ELSE.
    lv_msgid_nf = abap_true.
  ENDIF.

  IF <lfs_rm_details>-msgno IN li_msgnum.       " Messege Number
    lv_msgnum_nf = abap_false.
  ELSE.
    lv_msgnum_nf = abap_true.
  ENDIF.

  " delete the data looking at the range tables combination
  IF lv_msgnum_nf = abap_true OR lv_msgid_nf = abap_true .
    DELETE li_bg_detail INDEX sy-tabix.
  ENDIF.

ENDLOOP.

" prepare final output table
IF li_bg_detail IS NOT INITIAL.

  " Summarized data for the Messege type
  LOOP AT li_bg_detail ASSIGNING <lfs_rm_details>.
    st_subtotal-msgty = <lfs_rm_details>-msgty.       " Messege type
    st_subtotal-netwr = <lfs_rm_details>-netwr.       " net value

    COLLECT st_subtotal INTO i_subtotal.
    CLEAR st_subtotal.
  ENDLOOP.

  DATA(li_information) = li_bg_detail[].
  DATA(li_error)  = li_bg_detail[].

  DELETE ADJACENT DUPLICATES FROM li_information COMPARING ALL FIELDS.
  DELETE ADJACENT DUPLICATES FROM li_error COMPARING ALL FIELDS.

  DELETE li_information WHERE msgty NE lc_msgty_i.      " Delete error messeges
  DELETE li_error       WHERE msgty NE lc_msgty_e.      " delete informatin messeges
  CLEAR li_bg_detail[].

  " Information messege total
  READ TABLE i_subtotal INTO st_subtotal WITH KEY msgty = lc_msgty_i BINARY SEARCH.
  IF sy-subrc = 0.
    lv_inf_sub = st_subtotal-netwr.
    CLEAR st_subtotal.
  ENDIF.

  " Error messege total
  READ TABLE i_subtotal INTO st_subtotal WITH KEY msgty = lc_msgty_e BINARY SEARCH.
  IF sy-subrc = 0.
    lv_err_sub = st_subtotal-netwr.
    CLEAR st_subtotal.
  ENDIF.

  lv_total = lv_inf_sub + lv_err_sub.   " Total value

  APPEND INITIAL LINE TO li_bg_detail ASSIGNING <lfs_rm_details>.
  <lfs_rm_details>-netwr = lv_total.

  IF li_information IS NOT INITIAL.                                   " Information messeges sub total
    APPEND INITIAL LINE TO li_bg_detail ASSIGNING <lfs_rm_details>.
    <lfs_rm_details>-netwr = lv_inf_sub.
    <lfs_rm_details>-msgty = lc_msgty_i.
    APPEND LINES OF li_information TO li_bg_detail.                   " Append information messege details to BG process table
  ENDIF.

  IF li_error IS NOT INITIAL.
    APPEND INITIAL LINE TO li_bg_detail ASSIGNING <lfs_rm_details>.
    <lfs_rm_details>-netwr = lv_err_sub.                            " error messeges sub total
    <lfs_rm_details>-msgty = lc_msgty_e.
    APPEND LINES OF li_error TO li_bg_detail.           " Append error messege details to BG process table
  ENDIF.

ELSE.
  MESSAGE text-995 TYPE lc_msgty_i.
ENDIF.
