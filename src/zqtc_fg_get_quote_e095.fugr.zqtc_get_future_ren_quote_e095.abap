FUNCTION zqtc_get_future_ren_quote_e095.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_VBELN) TYPE  VBELN OPTIONAL
*"     VALUE(IM_POSNR) TYPE  POSNR OPTIONAL
*"  TABLES
*"      EX_VBFA STRUCTURE  VBFA OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_GET_FUTURE_REN_QUOTE_E095 (FM)
* PROGRAM DESCRIPTION: This FM is used to get Future renewal quote
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 09/30/2020
* OBJECT ID:     E095/ERPM-15095
* TRANSPORT NUMBER(S):ED2K919736
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
  CONSTANTS : lc_wricef_id   TYPE zdevid VALUE 'E095', "Development ID
              lc_ser_num_008 TYPE zsno   VALUE '008',  "Serial Number
              lc_param1      TYPE rvari_vnam VALUE 'AUART_FUTURE_QUOTE'.
  DATA:lv_activ_flag TYPE zactive_flag,
       lst_vbfa      TYPE vbfa,
       lv_vbeln      TYPE vbeln,
       li_constants  TYPE zcat_constants,
       lir_auart     TYPE TABLE OF EDM_AUART_RANGE.
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id
      im_ser_num     = lc_ser_num_008
    IMPORTING
      ex_active_flag = lv_activ_flag.
  IF lv_activ_flag IS NOT INITIAL.
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_wricef_id
      IMPORTING
        ex_constants = li_constants.
    IF li_constants IS NOT INITIAL.
*--*Get Quote Type
      LOOP AT li_constants INTO DATA(lst_constant).
        CASE lst_constant-param1.
          WHEN lc_param1.
            APPEND INITIAL LINE TO lir_auart
            ASSIGNING FIELD-SYMBOL(<lst_auart>).
            <lst_auart>-sign   = lst_constant-sign.
            <lst_auart>-option = lst_constant-opti.
            <lst_auart>-low    = lst_constant-low.
            <lst_auart>-high   = lst_constant-high.
        ENDCASE.
      ENDLOOP.
      CLEAR : lst_vbfa, lv_vbeln.
*--* Get Future Quote number by passing order into BNAME field at header
      SELECT SINGLE vbeln FROM vbak INTO @lv_vbeln WHERE bname = @im_vbeln
                                                   AND auart IN @lir_auart.
      IF sy-subrc EQ 0.
        lst_vbfa-vbeln = lv_vbeln.
        APPEND lst_vbfa TO ex_vbfa.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFUNCTION.
