*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E233_WLS_PRICING_COND_GP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_E233_WLS_PRICING_COND_GP(Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(MV45AFZZ)"
* PROGRAM DESCRIPTION: Populated the Condition Group 3 Value
* DEVELOPER:            VDPATABALL
* CREATION DATE:        10-MAR-2020
* OBJECT ID:            E233
* TRANSPORT NUMBER(S):  ED2K917715
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:li_const_t TYPE STANDARD TABLE OF lty_constant,
     lr_vkorg   TYPE sd_vkorg_ranges,
     lst_vkorg  TYPE sdsls_vkorg_range.
CONSTANTS:lc_dev_id TYPE zdevid     VALUE 'E233',    " Dev id
          lc_vkorg  TYPE rvari_vnam VALUE 'VKORG'. " Sales Org
IF li_const_t  IS INITIAL.
  FREE:li_const_t,lr_vkorg.
* fetch constant table entry for Sale Org 1101
  SELECT devid        " Development ID
         param1       " ABAP: Name of Variant Variable
         param2       " ABAP: Name of Variant Variable
         srno
         sign         " ABAP: ID: I/E (include/exclude values)
         opti         " ABAP: Selection option (EQ/BT/CP/...)
         low          " Lower Value of Selection Condition
         high         " Upper Value of Selection Condition
     FROM zcaconstant " Wiley Application Constant Table
     INTO TABLE li_const_t
     WHERE devid    EQ lc_dev_id
       AND activate EQ abap_true.
  IF sy-subrc EQ 0.
    SORT li_const_t BY devid param1 param2 low.
  ENDIF. " IF sy-subrc EQ 0
ENDIF."IF li_constant[] IS INITIAL.
CLEAR lst1_constant.
LOOP AT li_const_t INTO lst1_constant.
  CASE lst1_constant-param1.
    WHEN lc_vkorg.
      FREE:lst_vkorg.
      lst_vkorg-sign   = lst1_constant-sign.
      lst_vkorg-option = lst1_constant-opti.
      lst_vkorg-low    = lst1_constant-low.
      APPEND lst_vkorg TO lr_vkorg.
      CLEAR:lst_vkorg.
  ENDCASE.
ENDLOOP.

IF tkomk-vkorg IS NOT INITIAL AND lr_vkorg IS NOT INITIAL.
  IF  tkomk-vkorg IN lr_vkorg.
    IF tkomp-zzkdkg3 IS INITIAL.
      tkomp-zzkdkg3 = vbkd-kdkg3.       " Condition Group 3
    ENDIF.
  ENDIF.
ENDIF. "IF tkomk-vkorg IS NOT INITIAL.
