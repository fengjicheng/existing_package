*&---------------------------------------------------------------------*
*&  Include           ZRARR_SUBSCR_SCR
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED1K912234 / ED2K920165
* REFERENCE NO: INC0315954
* DEVELOPER: Bharani
* DATE:  10/07/2020
* DESCRIPTION: Token -Re-class Program optimization
*----------------------------------------------------------------------*

PARAMETERS: p_gjahr TYPE gjahr OBLIGATORY,
            p_poper TYPE poper OBLIGATORY,
* BOC - BTIRUVATHU - INC0315954   - 2020/07/10 - ED1K912234
            p_budat TYPE budat DEFAULT sy-datum.
* EOC - BTIRUVATHU - INC0315954   - 2020/07/10 - ED1K912234

SELECT-OPTIONS: so_ptype FOR lv_pob_type NO INTERVALS OBLIGATORY,
                so_vbeln FOR lv_vbeln NO INTERVALS.

PARAMETERS: p_disp AS CHECKBOX TYPE abap_bool DEFAULT abap_true.
PARAMETERS: p_zero AS CHECKBOX TYPE abap_bool DEFAULT abap_false.
