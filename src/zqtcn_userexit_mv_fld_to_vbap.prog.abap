*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales dokument item workaerea VBAP
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move KDMAT field
*                      into the sales dokument item workaerea VBAP
*                      and Partner function(ZX) to VBPA table
*                      Order Type is ZACO
* DEVELOPER: Venkata Durga Rao P(VDPATABALL)
* CREATION DATE:   08/22/2019
* OBJECT ID: E214 - ERPM-1452 & E215
* TRANSPORT NUMBER(S):ED2K915925
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAP(MV45AFZZ)"
* PROGRAM DESCRIPTION: When debit memo is created with BOM material using
*                      "ZQTCR_SUBSCRIP_ORDER_UPLOAD" program,
*                      1. UPFLU field of VBAP is set to '2' for all line
*                         items VBFA table is filled with respective records
* DEVELOPER: AMOHAMMED
* CREATION DATE:   09/12/2020
* OBJECT ID: E101 - ERPM-27580, 26293
* TRANSPORT NUMBER(S):ED2K920727
*----------------------------------------------------------------------*
* Begin of ADD:CR682:Yraulji:20-DEC-2017:1.	ED2K909950
* Local Data declaration
  DATA:
    lv_actv_flag_i0343 TYPE zactive_flag,         "Active / Inactive Flag
*---Begin of change VDPATABALL 22/08/2018    ED2K915925 CR# ERPM-1452
    lv_actv_flag_e214  TYPE zactive_flag,
    lv_actv_flag_e215  TYPE zactive_flag.

  DATA:lir_auart_range    TYPE fip_t_auart_range,
       lst_auart_range    TYPE fip_s_auart_range,
       lst_vkorg_range    TYPE fip_s_vkorg_range,
       lir_vkorg_range    TYPE fip_t_vkorg_range,
       lst_spart_range    TYPE fip_s_spart_range,
       lir_spart_range    TYPE fip_t_spart_range,
       lt_allocvaluesnum  TYPE STANDARD TABLE OF  bapi1003_alloc_values_num,
       lt_allocvalueschar TYPE STANDARD TABLE OF  bapi1003_alloc_values_char,
       lt_allocvaluescurr TYPE STANDARD TABLE OF  bapi1003_alloc_values_curr,
       lt_return_t        TYPE STANDARD TABLE OF  bapiret2,
       lv_objectkey       TYPE bapi1003_key-object,
       lv_objecttable     TYPE bapi1003_key-objecttable,
       lv_classnum        TYPE bapi1003_key-classnum,
       lv_classtype       TYPE bapi1003_key-classtype.
*--End of change VDPATABALL 22/08/2019 ED2K915925 CR# ERPM-1452
* Local constant Declaration
  CONSTANTS:
    lc_wricef_id_i0343 TYPE zdevid  VALUE 'I0343', "Development ID
    lc_sno_i0343_003   TYPE zsno    VALUE '003',  "Serial Number
*--Begin of change VDPATABALL 22/08/2019 ED2K915925 CR# ERPM-1452
    lc_wricef_id_e214  TYPE zdevid  VALUE 'E214', "Development ID
    lc_sno_e214_001    TYPE zsno    VALUE '001',  "Serial Number
    lc_auart           TYPE rvari_vnam  VALUE 'AUART',                    "Parameter: Order Type
    lc_vkorg           TYPE rvari_vnam  VALUE 'VKORG',                    "Parameter: Sale Org
    lc_spart           TYPE rvari_vnam  VALUE 'SPART',                    "Parameter: Division-
    lc_mara            TYPE bapi1003_key-objecttable VALUE 'MARA',        " Object Table
    lc_classnum        TYPE bapi1003_key-classnum    VALUE 'CHILD_COURSE', "Object Class
    lc_classtyp        TYPE bapi1003_key-classtype   VALUE '001',         "Class Type
    lc_wricef_id_e215  TYPE zdevid  VALUE 'E215', "Development ID
    lc_sno_e215_001    TYPE zsno    VALUE '001'.  "Serial Number

*--End of change VDPATABALL 22/08/2019 ED2K915925 CR# ERPM-1452
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0343
      im_ser_num     = lc_sno_i0343_003
    IMPORTING
      ex_active_flag = lv_actv_flag_i0343.

  IF lv_actv_flag_i0343 EQ abap_true.
    INCLUDE zqtcn_fill_vbap_mvgr3 IF FOUND.
  ENDIF.
* End   of ADD:CR682:Yraulji:20-DEC-2017:1.	ED2K909950
*--Begin of change VDPATABALL 22/08/2019 ED2K915925 CR# ERPM-1452
* To check enhancement is active or not
*----Below Include used for order type ZACO to populated the
*--- Material Number Used by Customer(KDMAT) to VBAP table
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e214
      im_ser_num     = lc_sno_e214_001
    IMPORTING
      ex_active_flag = lv_actv_flag_e214.

  IF lv_actv_flag_e214 EQ abap_true.
    INCLUDE zqtcn_fill_vbap_kdmat IF FOUND.
  ENDIF.

*----Below Include used for order type ZACO to populated the
*--- Partner function(ZX) to VBPA table
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e215
      im_ser_num     = lc_sno_e215_001
    IMPORTING
      ex_active_flag = lv_actv_flag_e215.

  IF lv_actv_flag_e215 EQ abap_true.
    INCLUDE zqtcn_fill_vbap_parvw IF FOUND.
  ENDIF.
*--End of change VDPATABALL 22/08/2019 ED2K915925 CR# ERPM-1452
*BOC by NPOLINA for OTCM-77925 on 13-June-2023 with ES1K901846
IF sy-uname = 'NPOLINA' OR sy-uname = 'SGURAJALA'.

  TYPES: BEGIN OF lty_auart_range,
         sign     TYPE tvarv_sign,          "ABAP: ID: I/E (include/exclude values)
         opti     TYPE tvarv_opti,          "ABAP: Selection option (EQ/BT/CP/...)
         low      TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
         high     TYPE salv_de_selopt_high, "Upper Value of Selection Condition
         END OF lty_auart_range.

  DATA: lir_auart12 TYPE TABLE OF lty_auart_range,
        lst_auart12 TYPE lty_auart_range,
        lv_mstdv  TYPE sy-datum.

  CLEAR: lst_auart12.
  lst_auart12-sign = 'I'.
  lst_auart12-opti = 'EQ'.
  lst_auart12-low = 'ZSUB'.
  APPEND lst_auart12 TO lir_auart12.

  CLEAR: lst_auart12.
  lst_auart12-sign = 'I'.
  lst_auart12-opti = 'EQ'.
  lst_auart12-low = 'ZREW'.
  APPEND lst_auart12 TO lir_auart12.

  CLEAR: lst_auart12.
  lst_auart12-sign = 'I'.
  lst_auart12-opti = 'EQ'.
  lst_auart12-low = 'ZSQT'.
  APPEND lst_auart12 TO lir_auart12.

  CLEAR: lst_auart12.
  lst_auart12-sign = 'I'.
  lst_auart12-opti = 'EQ'.
  lst_auart12-low = 'ZQT'.
  APPEND lst_auart12 TO lir_auart12.

  CONSTANTS: lc_t         TYPE c      VALUE 'S',
             lc_posnr     TYPE posnr  VALUE '000000'.

    IF lir_auart12[] IS NOT INITIAL AND xvbak-auart IN lir_auart12.
      SELECT SINGLE mstdv
          FROM MARA
          INTO lv_mstdv
          WHERE matnr = vbap-matnr AND
                mstav = lc_t.
      IF sy-subrc IS INITIAL AND lv_mstdv IS NOT INITIAL.
        IF veda-vposn = vbap-posnr.
          IF veda-vbegdat IS NOT INITIAL OR veda-venddat IS NOT INITIAL.
            IF ( lv_mstdv LT veda-vbegdat ) OR ( lv_mstdv GT veda-vbegdat AND lv_mstdv LT veda-venddat ).
              Message E268(ZQTC_R2) with vbap-posnr vbap-matnr.
            ENDIF.
          ENDIF.
        ELSEIF veda-vposn = lc_posnr.
          IF veda-vbegdat IS NOT INITIAL OR veda-venddat IS NOT INITIAL.
             IF ( lv_mstdv LT veda-vbegdat ) OR ( lv_mstdv GT veda-vbegdat AND lv_mstdv LT veda-venddat ).
                Message E268(ZQTC_R2) with vbap-posnr vbap-matnr.
             ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
ENDIF.
*BOC by NPOLINA for OTCM-77925 on 13-June-2023 with ES1K901846
* Begin by AMOHAMMED on 09/12/2020 TR : ED2K920727
  DATA lv_actv_flag_e101 TYPE zactive_flag. " Active / Inactive Flag
  CONSTANTS : lc_wricef_id_e101 TYPE zdevid  VALUE 'E101', "Development ID
              lc_sno_e101_002   TYPE zsno    VALUE '002'.  "Serial Number

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e101
      im_ser_num     = lc_sno_e101_002
    IMPORTING
      ex_active_flag = lv_actv_flag_e101.

  IF lv_actv_flag_e101 EQ abap_true.
    INCLUDE zqtcn_update_upflu_e101 IF FOUND.
  ENDIF.
* End by AMOHAMMED on 09/12/2020 TR : ED2K920727
