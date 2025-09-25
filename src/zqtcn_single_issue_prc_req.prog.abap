*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SINGLE_ISSUE_PRC_REQ(Include)
* PROGRAM DESCRIPTION: Ignore Discounts for Single Issue Pricing
* DEVELOPER: Lucky Kodwani (LKODWANI)
* CREATION DATE:   05/11/2017
* OBJECT ID: E087
* TRANSPORT NUMBER(S): ED2K906020
*----------------------------------------------------------------------*
DATA:
  lv_flg_sip TYPE flag.                               "Flag: Single Issue Pricing

* Check for Single Issue Pricing
CALL FUNCTION 'ZQTC_SINGLE_ISSUE_PRICING_DET'
  EXPORTING
    im_st_komk   = komk                               "Communication Header for Pricing
    im_st_komp   = komp                               "Communication Item for Pricing
  IMPORTING
    ex_v_flg_sip = lv_flg_sip.                        "Flag: Single Issue Pricing
IF lv_flg_sip IS INITIAL.
  sy-subrc = 0.                                       "Condition Type is allowed
ELSE.
  sy-subrc = 4.                                       "Condition Type is not allowed
  RETURN.
ENDIF.
