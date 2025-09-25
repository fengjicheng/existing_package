*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_POP_VBAP_FROM_VBAPKOM (Include)
* PROGRAM DESCRIPTION: Populate VBAP Fields from VBAPKOM
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10/13/2018
* OBJECT ID:       E131 (INC0205683)
* TRANSPORT NUMBER(S): ED1K908183
*----------------------------------------------------------------------*
* Cumulative Order Quantity in Sales Units
IF us_vbapkomx-updkz IS INITIAL.
  IF us_vbapkom-zmeng NE space.
    vbap-kwmeng = us_vbapkom-zmeng.
  ENDIF.
ELSE.
  PERFORM feld_fuellen_feldleiste(sapfv45s) USING us_vbapkom-zmeng
                                                  us_vbapkomx-zmeng
                                                  vbap-kwmeng.
ENDIF.
