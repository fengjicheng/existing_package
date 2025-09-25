*----------------------------------------------------------------------*
* PROGRAM NAME: QTCN_RESTRICT_PROMO_DISCOUNTS
* PROGRAM DESCRIPTION: Restrict Cond Type if Promo Code is missing
* DEVELOPER: Writtick Roy(WROY)
* CREATION DATE: 19-DEC-2016
* OBJECT ID: E075
* TRANSPORT NUMBER(S)ED2K903762
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906020
* REFERENCE NO: E087-CR#510
* DEVELOPER: Writtick Roy(WROY)
* DATE: 11-MAY-2017
* DESCRIPTION: Ignore Promo Discounts for Single Issue Pricing
*----------------------------------------------------------------------*
* Begin of ADD:CR#510:WROY:11-MAY-2017:ED2K906020
DATA:
  lv_flg_sip TYPE flag.                               "Flag: Single Issue Pricing

* Check for Single Issue Pricing
CALL FUNCTION 'ZQTC_SINGLE_ISSUE_PRICING_DET'
  EXPORTING
    im_st_komk   = komk                               "Communication Header for Pricing
    im_st_komp   = komp                               "Communication Item for Pricing
  IMPORTING
    ex_v_flg_sip = lv_flg_sip.                        "Flag: Single Issue Pricing
IF lv_flg_sip IS NOT INITIAL.
  sy-subrc = 4.                                       "Condition Type is not allowed
  RETURN.
ENDIF.
* END   of ADD:CR#510:WROY:11-MAY-2017:ED2K906020

sy-subrc = 4.
IF komp-kposn NE 0.
  IF komp-zzpromo IS INITIAL.
    RETURN.
  ENDIF.
ENDIF.
sy-subrc = 0.
