**&---------------------------------------------------------------------*
**&  Include           ZQTCN_PROFILE_BILLING_PLAN
**&---------------------------------------------------------------------*
*CONSTANTS : lc_xveda      TYPE char40     VALUE '(SAPLV45W)XVEDA[]'.
*FIELD-SYMBOLS : <lt_xveda> TYPE ztrar_vedavb.
*DATA : li_xveda           TYPE STANDARD TABLE OF vedavb.
*IF sy-uname = 'PTUFARAM' OR sy-uname = 'IYASIRU'.
*  ASSIGN (lc_xveda) TO <lt_xveda>.
*  IF <lt_xveda> IS ASSIGNED.
*
*    li_xveda[] =  <lt_xveda>.
*
*    DATA(lst_xveda) =   VALUE #( li_xveda[ vposn = vbap-posnr ] OPTIONAL ).
*    IF lst_xveda-vbegdat IS INITIAL.
*      lst_xveda =   VALUE #( li_xveda[ vposn = '00000000' ] OPTIONAL ).
*    ENDIF.
*    DATA lv_months TYPE vtbbewe-atage.
*    CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
*      EXPORTING
*        i_date_from = lst_xveda-vbegdat
**       i_key_day_from =
*        i_date_to   = lst_xveda-venddat
**       I_KEY_DAY_TO   =
**       I_FLG_SEPARATE = ' '
**       I_FLG_ROUND_UP = 'X'
*      IMPORTING
**       E_DAYS      =
*        e_months    = lv_months
**       E_YEARS     =
*      .
*    DATA: lv_fakwr TYPE fakwr.
*    DATA : lst_xvbap LIKE LINE OF xvbap.
*    lst_xvbap =   VALUE #( xvbap[ posnr = vbap-posnr ] OPTIONAL ).
*
*    DATA(lv_fplnr) = vbkd-fplnr.
*    IF lv_months IS NOT INITIAL AND lst_xvbap-netpr IS NOT INITIAL.
*      lv_fakwr = lst_xvbap-netpr / lv_months.
*      LOOP AT xfplt ASSIGNING FIELD-SYMBOL(<lst_xfplt>) WHERE fplnr = lv_fplnr.
*        <lst_xfplt>-fakwr = lv_fakwr.
*      ENDLOOP.
*    ENDIF.
*    lst_xvbap-netwr = lst_xvbap-netpr.
*    MODIFY xvbap  FROM lst_xvbap TRANSPORTING netwr WHERE posnr = vbap-posnr.
*    DATA : lv_netwr TYPE netwr.
*    LOOP AT xvbap INTO lst_xvbap.
*      lv_netwr =   lv_netwr + lst_xvbap-netwr.
*    ENDLOOP.
*    vbak-netwr = lv_netwr.
*  ENDIF.
*ENDIF.
