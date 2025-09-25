*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_ADD_FLDS_LIKPO01 (PBO Modules)
* PROGRAM DESCRIPTION: Delivery Custom Fields
* DEVELOPER: Aratrika Banerjee (ARABANERJE)
* CREATION DATE:   10/13/2016
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K903037
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  ZQTCE_SCREEN_MODE  OUTPUT
*&---------------------------------------------------------------------*
*       Screen Modification : Making Custom Fields uneditable in VA03
*       Transaction code
*----------------------------------------------------------------------*
MODULE mzqtc_screen_mode OUTPUT.

CONSTANTS : lc_vl03n TYPE char5 VALUE 'VL03N'.

  IF sy-tcode EQ lc_vl03n.
    LOOP AT SCREEN.
      IF screen-group1 = 'GR1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = 'GR1'
    ENDLOOP. " LOOP AT SCREEN
  ENDIF. " IF sy-tcode EQ lc_vl03n

ENDMODULE.
