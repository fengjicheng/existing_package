*&---------------------------------------------------------------------*
*&  Include  ZQTCN_WLS_SERIAL_NUM_E248
*&---------------------------------------------------------------------*
* PROGRAM NAME       : RV61B920
* PROGRAM DESCRIPTION:
* DEVELOPER          : murali (mimmadiset)
* CREATION DATE      : 06/11/2020
* OBJECT ID          : E248
* TRANSPORT NUMBER(S): ED2K915087
* PURPOSE            : To restrict the output determinataion based on the
*                      Condition
TYPES:BEGIN OF ty_sernp,
        sign   TYPE  ddsign,
        option TYPE  ddoption,
        low    TYPE  ism_pk_pstvy,
        high   TYPE  ism_pk_pstvy,
      END OF ty_sernp.
CONSTANTS:lc_doc_type   TYPE char1 VALUE 'J',   " Delivery document
          lc_devid_e248 TYPE zdevid VALUE 'E248',
          lc_sernp_e248 TYPE rvari_vnam    VALUE 'SERAIL',
          lc_vbtyp_c    TYPE vbtyp_v VALUE 'C'.
DATA:
  lv_xvbrp_e248        TYPE char40 VALUE '(SAPLV60A)XVBRP[]',     " Billing Document: Item Data
  lv_vbrk_e248         TYPE char40 VALUE '(SAPLV60A)VBRK',        " Billing Document: Header Data
  lv_xvbrp2_e248       TYPE char40 VALUE '(SAPMV60A)XVBRP[]',         " Billing Document: Item Data
  lv_vbrk2_e248        TYPE char40 VALUE '(SAPMV60A)VBRK',            " Billing Document: Header Data
  lst_vbrp_e248        TYPE vbrpvb,
  lt_vbrp_e248         TYPE vbrpvb_t,
  lv_flag_rc_e248      TYPE flag,                                 "Flag for Supress ZWLS out put type
  lv_vbeln_order       TYPE vbeln_va,
  lir_sernp_range_e248 TYPE STANDARD TABLE OF ty_sernp,
  li_constants_e248    TYPE zcat_constants.    "Constant Values

FIELD-SYMBOLS:
  <li_inv_lines_e248> TYPE vbrpvb_t,                           " Billing Document: Item Data
  <li_inv_hdr_e248>   TYPE vbrk.                               " Billing Document: Header Data
*---Check the Constant table before going to the actual logic.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e248  "Development ID
  IMPORTING
    ex_constants = li_constants_e248. "Constant Values

LOOP AT li_constants_e248[] ASSIGNING FIELD-SYMBOL(<lfs_constant_e248>).
*---Serial Number Profile constant value
  IF <lfs_constant_e248>-param1   = lc_sernp_e248.
    APPEND INITIAL LINE TO lir_sernp_range_e248 ASSIGNING FIELD-SYMBOL(<lst_sernp_range>).
    <lst_sernp_range>-sign   = <lfs_constant_e248>-sign.
    <lst_sernp_range>-option = <lfs_constant_e248>-opti.
    <lst_sernp_range>-low    = <lfs_constant_e248>-low.
  ENDIF.
ENDLOOP.
*-- Begin to get the sales doc from invoice item data in case of VF04/VF06 or background
ASSIGN (lv_vbrk_e248) TO <li_inv_hdr_e248>.
IF sy-subrc = 0.
  ASSIGN (lv_xvbrp_e248) TO <li_inv_lines_e248>.
  IF sy-subrc EQ 0.
    READ TABLE <li_inv_lines_e248> INTO DATA(lst_vbrp)
        WITH KEY vbeln = <li_inv_hdr_e248>-vbeln.
    IF sy-subrc = 0.
      lv_vbeln_order = lst_vbrp-aubel.
    ENDIF.
  ENDIF.
ENDIF.
IF lv_vbeln_order IS INITIAL.
  ASSIGN (lv_vbrk2_e248) TO <li_inv_hdr_e248>.
  IF sy-subrc = 0.
    ASSIGN (lv_xvbrp2_e248) TO <li_inv_lines_e248>.
    IF sy-subrc EQ 0.
      READ TABLE <li_inv_lines_e248> INTO lst_vbrp
          WITH KEY vbeln = <li_inv_hdr_e248>-vbeln.
      IF sy-subrc = 0.
        lv_vbeln_order = lst_vbrp-aubel.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
*-- Eoc  to get the sales doc from invoice item data.

IF lv_vbeln_order IS NOT INITIAL.
  SELECT matnr,werks FROM marc
                     INTO TABLE @DATA(lt_marc)
                     FOR ALL ENTRIES IN @<li_inv_lines_e248>
                     WHERE matnr = @<li_inv_lines_e248>-matnr AND
                           werks = @<li_inv_lines_e248>-werks AND
                           sernp IN @lir_sernp_range_e248.
  IF sy-subrc = 0.
    LOOP AT <li_inv_lines_e248> INTO lst_vbrp_e248.
      READ TABLE lt_marc INTO DATA(ls_marc) WITH KEY matnr = lst_vbrp_e248-matnr.
      IF sy-subrc = 0.
        APPEND lst_vbrp_e248 TO lt_vbrp_e248.
      ENDIF.
    ENDLOOP.
    IF lt_vbrp_e248[] IS NOT INITIAL.
      SORT lt_vbrp_e248 BY posnr.
      DELETE ADJACENT DUPLICATES FROM lt_vbrp_e248 COMPARING posnr.
      " Fetch Delivery number of the order
      SELECT vbelv,
           posnv,
           vbeln,
           posnn,
           vbtyp_n,
           vbtyp_v,
           matnr
               FROM vbfa
               INTO TABLE @DATA(lt_vbfa_ord)
               FOR ALL ENTRIES IN @lt_vbrp_e248
               WHERE vbelv = @lv_vbeln_order
                 AND posnv = @lt_vbrp_e248-posnr
                 AND vbtyp_n = @lc_doc_type.
      IF sy-subrc = 0.
        " Fetch object list number based on delivery number
        SELECT obknr, lief_nr,posnr
          FROM ser01
          INTO TABLE @DATA(li_ser01)
          FOR ALL ENTRIES IN @lt_vbfa_ord
          WHERE lief_nr EQ @lt_vbfa_ord-vbeln AND
                posnr EQ @lt_vbfa_ord-posnn.
        IF sy-subrc EQ 0.
          SORT li_ser01 BY obknr.
          " Fetch serial number and material based on object lis number
          SELECT obknr, sernr, matnr
            FROM objk
            INTO TABLE @DATA(li_objk)
            FOR ALL ENTRIES IN @li_ser01
            WHERE obknr EQ @li_ser01-obknr.
        ENDIF.
      ENDIF.
      LOOP AT lt_vbrp_e248 INTO DATA(ls_vbrp_248).
        READ TABLE lt_vbfa_ord INTO DATA(ls_vbfa_ord)
        WITH KEY vbelv =  lv_vbeln_order posnv = ls_vbrp_248-posnr.
        IF sy-subrc = 0.
          READ TABLE li_ser01 INTO DATA(ls_ser01)
                              WITH KEY lief_nr = ls_vbfa_ord-vbeln
                                       posnr = ls_vbfa_ord-posnn.
          IF sy-subrc = 0.
            READ TABLE li_objk INTO DATA(ls_objk) WITH KEY obknr = ls_ser01-obknr.
            IF sy-subrc NE 0.
              lv_flag_rc_e248 = abap_true.
              EXIT.
            ENDIF.
            IF ls_objk-sernr IS INITIAL.
              lv_flag_rc_e248 = abap_true.
              EXIT.
            ENDIF.
          ELSE.
            lv_flag_rc_e248 = abap_true.
            EXIT.
          ENDIF.
        ELSE.
"Delivery is not exist for the invoice, No output would be determined
          lv_flag_rc_e248 = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF."IF lt_vbrp_e248[] IS NOT INITIAL.
  ELSE.
*If there are no line items eligible for Serial number then allow the Output to be processed.
  ENDIF."IF sy-subrc = 0.
ELSE.
  lv_flag_rc_e248 = abap_true.
ENDIF."IF <li_inv_lines_e248> IS NOT INITIAL.




*----------------------------------------------------------------------*
******** Based on the return flag set the return code ***********
*----------------------------------------------------------------------*
IF lv_flag_rc_e248 = abap_true.
  sy-subrc = 4.    " " No output would be determined
ELSE.
  sy-subrc = 0.
ENDIF.
