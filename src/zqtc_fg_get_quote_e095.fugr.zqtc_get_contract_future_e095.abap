FUNCTION zqtc_get_contract_future_e095.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      T_RENEW STRUCTURE  ZQTC_RENWL_PLAN OPTIONAL
*"      T_VBFA STRUCTURE  VBFA OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_GET_FUTURE_REN_QUOTE_E095 (FM)
* PROGRAM DESCRIPTION: This FM is used to get reference contract for Future renewal quote
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 10/15/2020
* OBJECT ID:     E095/ERPM-15095
* TRANSPORT NUMBER(S):ED2K919935
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
  TYPES : BEGIN OF lty_vbak,
            vbeln TYPE vbeln,
            auart TYPE auart,
            bname TYPE bname_v,
            posnr TYPE posnr,
            matnr TYPE matnr,
          END OF lty_vbak.
  CONSTANTS : lc_wricef_id   TYPE zdevid VALUE 'E095', "Development ID
              lc_ser_num_009 TYPE zsno   VALUE '009',  "Serial Number
              lc_param1      TYPE rvari_vnam VALUE 'AUART_FUTURE_QUOTE'.
  DATA:lv_activ_flag TYPE zactive_flag,
       lst_vbfa      TYPE vbfa,
       lv_vbeln      TYPE vbeln,
       li_constants  TYPE zcat_constants,
       lir_auart     TYPE TABLE OF edm_auart_range,
       li_vbak       TYPE STANDARD TABLE OF lty_vbak.

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id
      im_ser_num     = lc_ser_num_009
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
    ENDIF.
*--*Get Contracts based on quote(ZSQT)
    IF t_renew[] IS NOT INITIAL.
      CLEAR : li_vbak.
      SELECT a~vbeln,
             a~auart,
             a~bname,
             b~posnr,
             b~matnr FROM vbak AS a INNER JOIN vbap AS b ON a~vbeln = b~vbeln
                                   INTO TABLE @li_vbak
                                   FOR ALL ENTRIES IN @t_renew
                                    WHERE a~vbeln = @t_renew-vbeln
                                      AND a~auart IN @lir_auart
                                      AND b~abgru = ' '
                                      AND b~uepos = '000000'.
      IF sy-subrc EQ 0.
*--*Build VBFA flow
        SORT li_vbak BY vbeln.
        LOOP AT t_renew INTO DATA(lst_renew).
          READ TABLE li_vbak INTO DATA(lst_vbak) WITH KEY vbeln = lst_renew-vbeln
                                                      BINARY SEARCH.
          IF sy-subrc EQ 0 AND lst_vbak-bname IS NOT INITIAL.
            lst_vbfa-vbelv = lst_vbak-bname.
            lst_vbfa-posnv = lst_vbak-posnr.
            lst_vbfa-matnr = lst_renew-matnr.
            lst_vbfa-vbeln = lst_vbak-vbeln.
            lst_vbfa-posnn = lst_renew-posnr.
            APPEND lst_vbfa TO t_vbfa.
            CLEAR lst_vbfa.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFUNCTION.
