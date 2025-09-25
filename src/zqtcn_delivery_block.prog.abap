*&---------------------------------------------------------------------*
*&  Include  ZQTCN_DELIVERY_BLOCK
*&---------------------------------------------------------------------*

DATA: lt_const  TYPE  zcat_constants,
      lv_create TYPE c,
      lr_auart  TYPE TABLE OF tds_rg_auart,
      lr_vkorg  TYPE TABLE OF range_vkorg,
      lr_zlsch  TYPE TABLE OF trty_rng_zlsch.

CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = 'E351'
  IMPORTING
    ex_constants = lt_const.

LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
  CASE <lfs_const>-param1.
    WHEN 'AUART'.
      APPEND INITIAL LINE TO lr_auart ASSIGNING FIELD-SYMBOL(<lfs_auart_i>).
      <lfs_auart_i>-sign = <lfs_const>-sign.
      <lfs_auart_i>-option = <lfs_const>-opti.
      <lfs_auart_i>-low = <lfs_const>-low.
      <lfs_auart_i>-high = <lfs_const>-high.
    WHEN 'VKORG'.
      lc_vkorg = <lfs_const>-low.
    WHEN 'ZLSCH'.
      APPEND INITIAL LINE TO lr_zlsch ASSIGNING FIELD-SYMBOL(<lfs_zlsch_i>).
      <lfs_zlsch_i>-sign = <lfs_const>-sign.
      <lfs_zlsch_i>-option = <lfs_const>-opti.
      <lfs_zlsch_i>-low = <lfs_const>-low.
      <lfs_zlsch_i>-high = <lfs_const>-high.
    WHEN OTHERS.
      "Do nothing.
  ENDCASE.
  CLEAR: <lfs_const>.
ENDLOOP.

*IF <lfs_t180_3>-trtyp = lv_create.
*  IF  lv_auart IN lr_auart.
*      IF sy-batch IS INITIAL AND sy-cprog = lc_ordcrepro. "Only fore ground changes
**        data(xvbak2) = xvbak.
*          READ TABLE xvbak INTO DATA(lst_vbak) WITH KEY vbeln = lw_vbak-vbeln.
*           IF sy-subrc = 0.
*             IF lst_vbak-vkorg = lc_vkorg.
*                 DATA(xvbkd2) = xvbkd5[].
*                 DELETE  xvbkd2 WHERE fplnr IS NOT INITIAL.
*                 READ TABLE xvbkd2 INTO DATA(lst_xvbkd2) INDEX 1.
*                   IF sy-subrc = 0.
*                       IF lst_xvbkd2-zlsch IN lr_zlsch.
*                         lst_vbak5-lifsk =  <lst_lifsk_i>-low.
*                       ENDIF.
*                   ENDIF.
*               ENDIF.
*           ENDIF.
*        ENDIF.
*  ENDIF.
*ENDIF.

*************************************************************************************************************

*CONSTANTS: lc_wricef_id_e351 TYPE zdevid VALUE 'E351', " Development ID
*           lc_ser_num_e351   TYPE zsno   VALUE '001',  " Serial Number
*           lc_crmd           TYPE trtyp  VALUE 'H',      " Transaction type Create Mode
*           lc_xvbkd          TYPE char40 VALUE '(SAPMV45A)XVBKD[]',
*           lc_vbak           TYPE char40 VALUE '(SAPMV45A)VBAK'.
**           lc_xvbak          TYPE char40 VALUE '(SAPMV45A)XVBAK'.
*
*DATA:    BEGIN OF xvbkd5 OCCURS 5.
*           INCLUDE STRUCTURE vbkdvb.
*         DATA:    END OF xvbkd5.
*
**DATA:    BEGIN OF xvbak5 OCCURS 5.
**           INCLUDE STRUCTURE vbak.
**         DATA:    END OF xvbak5.
*
*FIELD-SYMBOLS: <lfs_vbak>    TYPE any,
*               <li_xvbkd>    TYPE any.
**               <li_xvbak>    TYPE any.
*
*FIELD-SYMBOLS:<lfs_t180_3> TYPE t180.
*
*DATA: lv_actv_flag_e351   TYPE zactive_flag . " Active / Inactive Flag
*
*DATA:lst_vbak5 TYPE vbak.
*
** To check enhancement is active or not
*CALL FUNCTION 'ZCA_ENH_CONTROL'
*  EXPORTING
*    im_wricef_id   = lc_wricef_id_e351
*    im_ser_num     = lc_ser_num_e351
*  IMPORTING
*    ex_active_flag = lv_actv_flag_e351.
*
*IF lv_actv_flag_e351 EQ abap_true.
*  ASSIGN (lv_t180) TO <lfs_t180_3>.
*  IF <lfs_t180_3> IS ASSIGNED.
*    " Enhancement will work only in Create and Change Mode
*    IF <lfs_t180_3>-trtyp = lc_crmd. " Create Mode
*      "OR <lfs_t180_3>-trtyp = lc_chmd.    " Change Mode
*
** Fetch Business Data
*      ASSIGN (lc_xvbkd) TO <li_xvbkd>.
*      IF <li_xvbkd> IS ASSIGNED.
*        xvbkd5[] = <li_xvbkd>.
*      ENDIF.
*
**      ASSIGN (lc_xvbak) TO <li_xvbak>.
**      IF <li_xvbak> IS ASSIGNED.
**        xvbak5[] = <li_xvbak>.
**      ENDIF.
*
*      ASSIGN (lc_vbak) TO <lfs_vbak>.
*      IF <lfs_vbak> IS ASSIGNED.
*        lst_vbak5 = <lfs_vbak>.
*      ENDIF.
*
*      IF <lfs_vbak> IS ASSIGNED
*        AND <li_xvbkd> IS ASSIGNED.
**        AND <li_xvbak> IS ASSIGNED.
*        "This include update the delivery block
*        INCLUDE zqtcn_delivery_block IF FOUND.
*        <lfs_vbak> = lst_vbak5 .
*      ENDIF.
*    ENDIF. " IF lv_actv_flag EQ abap_true
*  ENDIF.
*ENDIF.

**************************************************************************************************************************
**************************************************************************************************************************

*IF <lfs_t180_3>-trtyp = lv_create.
*  IF  lv_auart IN lr_auart.
**        data(xvbak2) = xvbak.
*          READ TABLE xvbak INTO DATA(lst_vbak) WITH KEY vbeln = lw_vbak-vbeln.
*          IF lst_vbak-vkorg = lc_vkorg.
*          DATA(xvbkd2) = xvbkdd5[].
*          DELETE  xvbkd2 WHERE fplnr IS NOT INITIAL.
*          READ TABLE xvbkd2 INTO DATA(lst_xvbkd2) INDEX 1.
*            IF sy-subrc = 0.
*                IF lst_xvbkd2-zlsch IN lr_zlsch.
*                  lst_vbakk5-lifsk =  <lst_lifsk_i>-low.
*                ENDIF.
*            ENDIF.
*         ENDIF.
*      ENDIF.
*  ENDIF.
*ENDIF.
*
**************************************************************************************************************
*
*CONSTANTS: lc_wricef_id_e351 TYPE zdevid VALUE 'E351', " Development ID
*           lc_ser_num_e351   TYPE zsno   VALUE '001',  " Serial Number
*           lc_crmd1           TYPE trtyp  VALUE 'H',      " Transaction type Create Mode
*           lc_xvbkd1          TYPE char40 VALUE '(SAPMV45A)XVBKD[]',
*           lc_vbak1           TYPE char40 VALUE '(SAPMV45A)VBAK'.
**           lc_xvbak          TYPE char40 VALUE '(SAPMV45A)XVBAK'.
*
*DATA:    BEGIN OF xvbkdd5 OCCURS 5.
*           INCLUDE STRUCTURE vbkdvb.
*         DATA:    END OF xvbkdd5.
*
**DATA:    BEGIN OF xvbak5 OCCURS 5.
**           INCLUDE STRUCTURE vbak.
**         DATA:    END OF xvbak5.
*
*FIELD-SYMBOLS: <lfs_vbak1>    TYPE any,
*               <li_xvbkd1>    TYPE any.
**               <li_xvbak>    TYPE any.
*
*FIELD-SYMBOLS:<lfs_t180_3> TYPE t180.
*
*DATA: lv_actv_flag_e351   TYPE zactive_flag . " Active / Inactive Flag
*
*DATA:lst_vbakk5 TYPE vbak.
*
** To check enhancement is active or not
*CALL FUNCTION 'ZCA_ENH_CONTROL'
*  EXPORTING
*    im_wricef_id   = lc_wricef_id_e351
*    im_ser_num     = lc_ser_num_e351
*  IMPORTING
*    ex_active_flag = lv_actv_flag_e351.
*
*IF lv_actv_flag_e351 EQ abap_true.
*  ASSIGN (lv_t180) TO <lfs_t180_3>.
*  IF <lfs_t180_3> IS ASSIGNED.
*    " Enhancement will work only in Create and Change Mode
*    IF <lfs_t180_3>-trtyp = lc_crmd1. " Create Mode
*      "OR <lfs_t180_3>-trtyp = lc_chmd.    " Change Mode
*
** Fetch Business Data
*      ASSIGN (lc_xvbkd1) TO <li_xvbkd1>.
*      IF <li_xvbkd1> IS ASSIGNED.
*        xvbkdd5[] = <li_xvbkd1>.
*      ENDIF.
*
**      ASSIGN (lc_xvbak) TO <li_xvbak>.
**      IF <li_xvbak> IS ASSIGNED.
**        xvbak5[] = <li_xvbak>.
**      ENDIF.
*
*      ASSIGN (lc_vbak1) TO <lfs_vbak1>.
*      IF <lfs_vbak1> IS ASSIGNED.
*        lst_vbakk5 = <lfs_vbak1>.
*      ENDIF.
*
*      IF <lfs_vbak1> IS ASSIGNED
*        AND <li_xvbkd1> IS ASSIGNED.
**        AND <li_xvbak> IS ASSIGNED.
*        "This include update the delivery block
*        INCLUDE zqtcn_delivery_block IF FOUND.
*        <lfs_vbak1> = lst_vbakk5 .
*      ENDIF.
*    ENDIF. " IF lv_actv_flag EQ abap_true
*  ENDIF.
*ENDIF.
