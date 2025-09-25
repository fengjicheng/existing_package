*&---------------------------------------------------------------------*
*&  Include  ZQTCN_ORD_DISABLE_QTY_ITEM_CAT
*&---------------------------------------------------------------------*

DATA : lt_zcaconstant TYPE STANDARD TABLE OF zcaconstant INITIAL SIZE 0,
       ls_zcaconstant TYPE zcaconstant. " Wiley Application Constant Table

CONSTANTS: c_devid  TYPE zdevid VALUE 'E075',
           c_param1 TYPE rvari_vnam VALUE 'ITEM_CATEGORY'.
CONSTANTS: c_tcode TYPE syst_tcode VALUE 'VA42'.

IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
  IF sy-tcode EQ c_tcode.

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
    READ TABLE lt_zcaconstant INTO ls_zcaconstant WITH KEY low = vbap-pstyv BINARY SEARCH.
    IF sy-subrc = 0.
      IF ls_zcaconstant-activate EQ space.
        IF screen-name = 'VBAP-ZMENG'.
          screen-input = 0.
        ENDIF.

        IF screen-name = 'VBAP-PSTYV'.
          screen-input = 0.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
