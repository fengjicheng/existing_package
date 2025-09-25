*----------------------------------------------------------------------*
***INCLUDE LZQTCV_I0255_SPLTF01.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K912635
* REFERENCE NO: INC0334801
* DEVELOPER: Nikhilesh (NPALLA)
* DATE: 01/22/2021
* DESCRIPTION: Validate New entries to not allow Blank Key Fields and
*              not allow duplicate records (all fields except Sequence Number).
*----------------------------------------------------------------------*
FORM f_upd_seq_and_valdt_mdprd.

  FIELD-SYMBOLS:
      <lv_field> TYPE any.                                        "Field Value

  CONSTANTS:
    lc_f_zseqno   TYPE viewfield  VALUE 'ZSEQNO'.

  DATA: lv_zseqno       TYPE fin_seqno,
        lst_i0255_split TYPE zqtc_i0255_split.

  DATA: li_i0255_split TYPE STANDARD TABLE OF zqtc_i0255_split.

* DATA(li_tot_rec) = total[].
  MOVE-CORRESPONDING total[] TO li_i0255_split.

  CLEAR lv_zseqno.
  SORT li_i0255_split BY zseqno DESCENDING.
  READ TABLE li_i0255_split INTO lst_i0255_split INDEX 1.
  IF sy-subrc EQ 0.
    lv_zseqno = lst_i0255_split-zseqno + 1.
  ELSE.
    lv_zseqno = 1.
  ENDIF.

  IF <table1> IS ASSIGNED.
    ASSIGN COMPONENT lc_f_zseqno OF STRUCTURE <table1> TO <lv_field>.
    <lv_field> = lv_zseqno.
  ENDIF.

* BOC - NPALLA - INC0334801 - ED1K912635 - 01/22/2021
* Check for Blank Fields.
  DATA: lv_blank TYPE xfeld.

  IF <table1> IS ASSIGNED.
    ASSIGN COMPONENT 'LABLTP' OF STRUCTURE <table1> TO <lv_field>.
    IF <lv_field> IS INITIAL.
      lv_blank = abap_true.
    ENDIF.
    IF lv_blank IS INITIAL.
      ASSIGN COMPONENT 'VARNAME' OF STRUCTURE <table1> TO <lv_field>.
      IF <lv_field> IS INITIAL.
        lv_blank = abap_true.
      ENDIF.
    ENDIF.
    IF lv_blank IS INITIAL.
      ASSIGN COMPONENT 'MEDIA_PRODUCT' OF STRUCTURE <table1> TO <lv_field>.
      IF <lv_field> IS INITIAL.
        lv_blank = abap_true.
      ENDIF.
    ENDIF.
    IF NOT lv_blank IS INITIAL.
      message e000(zqtc_r2) with 'Blank Key Fields Not Allowed'(001).
      vim_abort_saving = 'X'.
      exit.
    ENDIF.
  ENDIF.

* Check for Duplicate entry (exclude zseqno, as this is derived above and is unique).
  CLEAR lst_i0255_split.
  lst_i0255_split = <table1>.
  READ TABLE li_i0255_split TRANSPORTING NO FIELDS WITH KEY
                                         mandt             = lst_i0255_split-mandt
                                         labltp            = lst_i0255_split-labltp
                                         varname           = lst_i0255_split-varname
                                         "zseqno            = lst_i0255_split-zseqno
                                         media_product     = lst_i0255_split-media_product
                                         media_issue       = lst_i0255_split-media_issue
                                         price_grp         = lst_i0255_split-price_grp
                                         ship_to_code      = lst_i0255_split-ship_to_code
                                         society_grp_code  = lst_i0255_split-society_grp_code
                                         reason_code       = lst_i0255_split-reason_code
                                         subscription_cls  = lst_i0255_split-subscription_cls
                                         sales_org         = lst_i0255_split-sales_org
                                         condition_grp2    = lst_i0255_split-condition_grp2
                                         cntrl_circulation = lst_i0255_split-cntrl_circulation
                                         varsplit          = lst_i0255_split-varsplit
                                         email             = lst_i0255_split-email.
  IF sy-subrc = 0.
    message e000(zqtc_r2) with 'Duplicate Entry Not Allowed'(002)
                               ' - Including All Non-Key Fields'(003).
    vim_abort_saving = 'X'.
    exit.
  ENDIF.
* EOC - NPALLA - INC0334801 - ED1K912635 - 01/22/2021

*  IF <vim_total_struc> IS ASSIGNED.
*    MOVE-CORRESPONDING <vim_total_struc> TO lst_i0255_split.
* To Extract the Maximum Sequence number for the givenn label type, varname,
* media Product.
*    SELECT MAX( zseqno ) INTO lv_zseqno
*        FROM zqtc_i0255_split.
*        WHERE labltp  EQ lst_i0255_split-labltp
*          AND varname EQ lst_i0255_split-varname
*          AND media_product EQ lst_i0255_split-media_product.
*    IF sy-subrc EQ 0.
*      lv_zseqno = lv_zseqno + 1.
*    ELSE.
*      lv_zseqno = 1.
*    ENDIF.
*
*    LOOP AT total.
*      IF <action> = neuer_eintrag.                              "Create New Entry (N)
*        ASSIGN COMPONENT lc_f_zseqno OF STRUCTURE <vim_total_struc> TO <lv_field>.
*      IF sy-subrc EQ 0.
*        <lv_field> = lv_zseqno + 1.                         "Current Time of Application Server
*      ENDIF.
*
*      MODIFY total.
**
*      READ TABLE extract WITH KEY <vim_xtotal_key>.
*      IF sy-subrc EQ 0.
*        extract = total.
*        MODIFY extract INDEX sy-tabix.
*      ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
ENDFORM.
