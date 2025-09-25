*&---------------------------------------------------------------------*
*&  Include  ZQTCN_SOLDTO_VAT_IDT_I0230_2
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SOLDTO_VAT_IDT_I0230_2 (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMK(MV45AFZZ)"
* PROGRAM DESCRIPTION: Update VAT Registration number from Shipto Party
*                      to Sold To, which gets updated to IDT
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE:   03/23/2021
* OBJECT ID: I0230.2 - OTCM-27280
* TRANSPORT NUMBER(S): ED2K922686
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
CONSTANTS:
  lc_id_i0230    TYPE zdevid         VALUE 'I0230.2',
  lc_auart_i0230 TYPE rvari_vnam VALUE 'AUART_MAP_VAT',
  lc_parvw_map   TYPE rvari_vnam VALUE 'PARVW_MAP_VAT',
  lc_header_itm  TYPE posnr VALUE '000000',
  lc_we          TYPE parvw VALUE 'WE',
  lc_cremd       TYPE t180-trtyp VALUE 'H',       "Create Mode
  lc_chgmd       TYPE t180-trtyp VALUE 'V'.       "Change Mode.
DATA : lv_tabix TYPE sy-tabix.
IF li_const_i0230 IS INITIAL.
* Get data from constant table
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_id_i0230
    IMPORTING
      ex_constants = li_const_i0230.
  LOOP AT li_const_i0230 ASSIGNING FIELD-SYMBOL(<lst_const_i0230>).
    CASE <lst_const_i0230>-param1.
      WHEN lc_auart_i0230.                   "Order Type ZPPV
        APPEND INITIAL LINE TO lir_auart_vat ASSIGNING FIELD-SYMBOL(<lst_auart>).
        <lst_auart>-sign   = <lst_const_i0230>-sign.
        <lst_auart>-option = <lst_const_i0230>-opti.
        <lst_auart>-low    = <lst_const_i0230>-low.
        <lst_auart>-high   = <lst_const_i0230>-high.
      WHEN lc_parvw_map.                    "Partner functions
        APPEND INITIAL LINE TO lir_parvw_vat ASSIGNING FIELD-SYMBOL(<lst_parvw>).
        <lst_parvw>-sign   = <lst_const_i0230>-sign.
        <lst_parvw>-option = <lst_const_i0230>-opti.
        <lst_parvw>-low    = <lst_const_i0230>-low.
        <lst_parvw>-high   = <lst_const_i0230>-high.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.
ENDIF.
*--*Check transaction type
IF t180-trtyp = lc_cremd OR t180-trtyp = lc_chgmd.
*--*Check Order Type
  IF lir_auart_vat IS NOT INITIAL AND vbak-auart IN lir_auart_vat.
*--*Read Shipto Vat Reg Num
    READ TABLE xvbpa INTO DATA(lst_xvbpa_we) WITH KEY  vbeln = vbak-vbeln
                                                    posnr = lc_header_itm
                                                    parvw = lc_we.
*--*Check if Vat Reg Num maintained at Shipto level
    IF sy-subrc EQ 0 AND lst_xvbpa_we-stceg IS NOT INITIAL.
      LOOP AT xvbpa INTO DATA(lst_xvbpa) WHERE  vbeln = vbak-vbeln
                                             AND    posnr = lc_header_itm
                                             AND    parvw IN lir_parvw_vat.
        lv_tabix = sy-tabix.
*--*Map Ship to Vat Reg Num  To SoldTo Vat Reg Num
          lst_xvbpa-stceg = lst_xvbpa_we-stceg.
          MODIFY xvbpa FROM lst_xvbpa INDEX lv_tabix TRANSPORTING stceg.
      ENDLOOP.
    ENDIF. "IF sy-subrc EQ 0 AND lst_xvbpa-stceg IS NOT INITIAL.
  ENDIF. "IF lir_auart_vat IS NOT INITIAL AND vbak-auart IN lir_auart_vat.
ENDIF. "IF t180-trtyp = lc_cremd OR t180-trtyp = lc_chgmd.
