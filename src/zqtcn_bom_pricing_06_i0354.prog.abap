*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BOM_PRICING_06_I0354
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_PRICING_06_I0354 (Include)
*               Called from ZQTCEI_BOM_DECIMALS_I0354
* PROGRAM DESCRIPTION: Adjust Price for BOM Components
* DEVELOPER: PRABHU
* CREATION DATE:   29-MARCH-2019
* OBJECT ID: I0354
* TRANSPORT NUMBER(S): ED2K914836
*----------------------------------------------------------------------*
STATICS : li_const   TYPE zcat_constants.
CONSTANTS : lc_doctype  TYPE char10 VALUE 'DOC_TYPE',
            lc_price    TYPE char10 VALUE 'PRICE',
            lc_material TYPE char10 VALUE 'MATERIAL',
            lc_devid    TYPE zdevid      VALUE 'I0354'.
DATA : lir_material TYPE blgl_matnr_range_tt,
       lir_doctype  TYPE rjksd_auart_range_tab.
IF vbap EQ *vbap AND call_bapi = abap_true.
  IF li_const IS INITIAL.
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_devid
      IMPORTING
        ex_constants = li_const.
  ENDIF.
**-**Build constants
  LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_doctype.                                        "Doc type
        CASE <lst_const>-param2.
          WHEN lc_price.
            APPEND INITIAL LINE TO lir_doctype ASSIGNING FIELD-SYMBOL(<lst_doctype>).
            <lst_doctype>-sign   = <lst_const>-sign.
            <lst_doctype>-option = <lst_const>-opti.
            <lst_doctype>-low    = <lst_const>-low.
            <lst_doctype>-high   = <lst_const>-high.
          WHEN OTHERS.
        ENDCASE.
      WHEN lc_material.
        CASE <lst_const>-param2.
          WHEN lc_price.                             "Material
            APPEND INITIAL LINE TO lir_material ASSIGNING FIELD-SYMBOL(<lst_material>).
            <lst_material>-sign   = <lst_const>-sign.
            <lst_material>-option = <lst_const>-opti.
            <lst_material>-low    = <lst_const>-low.
            <lst_material>-high   = <lst_const>-high.
          WHEN OTHERS.
        ENDCASE.
      WHEN OTHERS.
*           Nothing to do
    ENDCASE.
  ENDLOOP.
*--*Makesure VBAP NE *VBAP
  READ TABLE xvbap INTO DATA(lst_vbap) WITH KEY posnr = vbap-uepos.
  IF sy-subrc EQ 0.
    IF vbak-auart IN lir_doctype AND lst_vbap-matnr IN lir_material.
      IF vbap-kzwi6 = *vbap-kzwi6.
        *vbap-kzwi6 = vbap-netwr.
      ELSE.
        CLEAR *vbap-kzwi6.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
