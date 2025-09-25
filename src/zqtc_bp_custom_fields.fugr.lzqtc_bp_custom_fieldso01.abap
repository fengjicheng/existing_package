*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_BP_CUSTOM_FIELDSO01 (PBO Modules)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  SALES_AREA_TEXT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE sales_area_text OUTPUT.
  IF knvv-spart EQ space.
    CLEAR st_tspat.
  ELSE.
    IF st_tspat-spras NE sy-langu
    OR st_tspat-spart NE knvv-spart.
      SELECT SINGLE *
        FROM tspat
        INTO st_tspat
       WHERE spras = sy-langu
         AND spart = knvv-spart.
      IF sy-subrc NE 0.
        CLEAR st_tspat.
      ENDIF.
    ENDIF.
  ENDIF.

  IF knvv-vkorg EQ space.
    CLEAR st_tvkot.
  ELSE.
    IF st_tvkot-spras NE sy-langu
    OR st_tvkot-vkorg NE knvv-vkorg.
      SELECT SINGLE *
        FROM tvkot
        INTO st_tvkot
       WHERE spras = sy-langu
         AND vkorg = knvv-vkorg.
      IF sy-subrc NE 0.
        CLEAR st_tvkot.
      ENDIF.
    ENDIF.
  ENDIF.

  IF knvv-vtweg EQ space.
    CLEAR st_tvtwt.
  ELSE.
    IF st_tvtwt-spras NE sy-langu
    OR st_tvtwt-vtweg NE knvv-vtweg.
      SELECT SINGLE *
        FROM tvtwt
        INTO st_tvtwt
       WHERE spras = sy-langu
         AND vtweg = knvv-vtweg.
      IF sy-subrc NE 0.
        CLEAR st_tvtwt.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.

  CONSTANTS:
    lc_grp_cf  TYPE char3 VALUE 'CF1',
    lc_grp_cst TYPE char3 VALUE 'CST',
    lc_inp_0   TYPE char1 VALUE '0',
    lc_inp_1   TYPE char1 VALUE '1'.

  LOOP AT SCREEN.
    IF screen-group1 EQ lc_grp_cf.
      IF v_activity EQ c_display.
        screen-input = lc_inp_0.
      ELSE.
        screen-input = lc_inp_1.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.

    IF v_cntrl_bp    EQ abap_true AND
       screen-group1 EQ lc_grp_cst.
      screen-active = lc_inp_0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  BUS_PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE bus_pbo OUTPUT.
  IF v_cntrl_bp EQ abap_true.
    CALL FUNCTION 'BUS_PBO'.
  ENDIF.
ENDMODULE.
