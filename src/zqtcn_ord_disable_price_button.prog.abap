*&---------------------------------------------------------------------*
*&  Include  ZQTCN_ORD_DISABLE_PRICE_BUTTON
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911531
* REFERENCE NO:  E075
* DEVELOPER:  Agudurkhad
* DATE:  2018-03-25
* DESCRIPTION: Disable item qty and item category for converted Orders
* Change Tag :
* Begin of ADD:E075:Agudurkhad:2018-03-25:ED2K911531
* End   of ADD:E075:Agudurkhad:2018-03-25:ED2K911531
*-----------------------------------------------------------------------*
DATA : lt_zcaconstant TYPE STANDARD TABLE OF zcaconstant INITIAL SIZE 0,
       ls_zcaconstant TYPE zcaconstant. " Wiley Application Constant Table

CONSTANTS: c_devid  TYPE zdevid VALUE 'E075',
           c_param1 TYPE rvari_vnam VALUE 'ITEM_CATEGORY'.
CONSTANTS: c_tcode TYPE syst_tcode VALUE 'VA42'.

DATA: ls_komv TYPE komv.
DATA: lt_xvbap TYPE STANDARD TABLE OF  vbapvb.
DATA: ls_xvbap TYPE  vbapvb.
DATA: l_table_name(20) TYPE c VALUE '(SAPMV45A)XVBAP[]'.
CLEAR ls_komv.


FIELD-SYMBOLS: <tab> TYPE any,
               <wa>  TYPE vbapvb.
IF sy-batch IS INITIAL .
  IF sy-tcode EQ c_tcode.
    ASSIGN (l_table_name) TO <tab>.
    IF <tab> IS ASSIGNED.
      lt_xvbap = <tab>.

      READ  TABLE xkomv INTO ls_komv INDEX 1.
*Check sy-subrc

      CLEAR ls_xvbap.
      READ TABLE lt_xvbap INTO ls_xvbap WITH KEY posnr = ls_komv-kposn.
*Check sy-subrc
*

      IF lt_zcaconstant[] IS INITIAL.
        SELECT * INTO TABLE lt_zcaconstant
                  FROM zcaconstant
                  WHERE devid = c_devid
                  AND param1 = c_param1.
        IF sy-subrc = 0.
          SORT lt_zcaconstant BY low.
        ENDIF.
      ENDIF.
      CLEAR ls_zcaconstant.
      READ TABLE lt_zcaconstant INTO ls_zcaconstant WITH KEY low = ls_xvbap-pstyv BINARY SEARCH.
      IF sy-subrc = 0.
        IF ls_zcaconstant-activate EQ space.
          IF screen-name = 'BT_KONY'.
            screen-input = 0.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
