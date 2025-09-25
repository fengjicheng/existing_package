*&---------------------------------------------------------------------*
*&  Include  ZQTCN_DELVBLK_OUTPUTBLOCK_E351
*&---------------------------------------------------------------------*
* INCLUDE NAME: ZQTCN_DELVBLK_900_E351                                 *
* PROGRAM DESCRIPTION: This include will deactivate the ZOA2 output    *
*            if the sales org, document type and delvery block matches *
*            as per the constant table entries.                        *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 03/23/2022                                          *
* OBJECT ID      : E351                                                *
* TRANSPORT NUMBER(S): ED2K926206                                      *
*----------------------------------------------------------------------*
DATA: lt_const      TYPE zcat_constants,
      lr_auart_e351 TYPE TABLE OF tds_rg_auart,
      lr_vkorg_e351 TYPE TABLE OF fkkr_vkorg,
      lr_lifsk_e351 TYPE TABLE OF bapidlv_range_lifsk,
      lr_kschl_e351 TYPE TABLE OF kschl_ran,
      lv_t180       TYPE string VALUE '(SAPMV45A)T180',
      lv_xvbak      TYPE string VALUE '(SAPMV45A)XVBAK',
      lv_xnast      TYPE string VALUE '(SAPLV61B)XNAST[]',
      lst_vbakst    TYPE vbak.

CONSTANTS: lc_devid_e351 TYPE zdevid VALUE 'E351',
           lc_crmd_e351  TYPE trtyp  VALUE 'H',
           lc_chmd_e351  TYPE trtyp  VALUE 'V',
           lc_xvbak      TYPE char40 VALUE '(SAPMV45A)XVBAK'.

FIELD-SYMBOLS:<lfs_xvbak>     TYPE any,
              <lfs_t180_2>    TYPE t180,
              <li_xnast_e351> TYPE any.

* current messages
DATA:    xnast_e351 LIKE vnast OCCURS 20 WITH HEADER LINE.

CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e351
  IMPORTING
    ex_constants = lt_const.

LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
  CASE <lfs_const>-param1.
    WHEN 'AUART'.
      APPEND INITIAL LINE TO lr_auart_e351 ASSIGNING FIELD-SYMBOL(<lfs_auart_i>).
      <lfs_auart_i>-sign = <lfs_const>-sign.
      <lfs_auart_i>-option = <lfs_const>-opti.
      <lfs_auart_i>-low = <lfs_const>-low.
      <lfs_auart_i>-high = <lfs_const>-high.
    WHEN 'LIFSK'.
      APPEND INITIAL LINE TO lr_lifsk_e351 ASSIGNING FIELD-SYMBOL(<lfs_lifsk_i>).
      <lfs_lifsk_i>-sign = <lfs_const>-sign.
      <lfs_lifsk_i>-option = <lfs_const>-opti.
      <lfs_lifsk_i>-dlv_block_low = <lfs_const>-low.
      <lfs_lifsk_i>-dlv_block_high = <lfs_const>-high.
    WHEN 'VKORG'.
      APPEND INITIAL LINE TO lr_vkorg_e351 ASSIGNING FIELD-SYMBOL(<lfs_vkorg_i>).
      <lfs_vkorg_i>-sign = <lfs_const>-sign.
      <lfs_vkorg_i>-option = <lfs_const>-opti.
      <lfs_vkorg_i>-low = <lfs_const>-low.
      <lfs_vkorg_i>-high = <lfs_const>-high.
    WHEN 'OUTPUTTYPE'.
      APPEND INITIAL LINE TO lr_kschl_e351 ASSIGNING FIELD-SYMBOL(<lfs_kschl_i>).
      <lfs_kschl_i>-sign = <lfs_const>-sign.
      <lfs_kschl_i>-option = <lfs_const>-opti.
      <lfs_kschl_i>-low = <lfs_const>-low.
      <lfs_kschl_i>-high = <lfs_const>-high.
    WHEN OTHERS.
      "Do nothing.
  ENDCASE.
  CLEAR: <lfs_const>.
ENDLOOP.


ASSIGN (lv_t180) TO <lfs_t180_2>.
ASSIGN (lv_xnast)  TO <li_xnast_e351>.
IF <li_xnast_e351> IS ASSIGNED.
  xnast_e351[] = <li_xnast_e351>.
ENDIF.

IF <lfs_t180_2> IS ASSIGNED.
  IF <lfs_t180_2>-trtyp = lc_crmd_e351 OR <lfs_t180_2>-trtyp = lc_chmd_e351 .
    " For ZSUB,ZREW document types and if delivery block is DD then ZOA2 will be stopped
    IF vbak-auart IN lr_auart_e351 AND vbak-lifsk IN lr_lifsk_e351
    AND vbak-vkorg IN lr_vkorg_e351.
      LOOP AT xnast_e351
        ASSIGNING FIELD-SYMBOL(<lfs_xnast1>)
        WHERE kschl IN lr_kschl_e351.
        <lfs_xnast1>-aktiv = abap_true.
      ENDLOOP.
      IF  xnast_e351[] IS NOT INITIAL
      AND <li_xnast_e351> IS ASSIGNED.
        <li_xnast_e351> =  xnast_e351[].
      ENDIF.
      " For ZSUB, ZREW document types and if delivery block is DD then ZOA2 will be processed.
    ELSEIF vbak-auart IN lr_auart_e351 AND vbak-lifsk IS INITIAL
    AND vbak-vkorg IN lr_vkorg_e351.
      LOOP AT xnast_e351
        ASSIGNING FIELD-SYMBOL(<lfs_xnast2>)
        WHERE kschl IN lr_kschl_e351.
        CLEAR <lfs_xnast2>-aktiv .
      ENDLOOP.
      IF  xnast_e351[] IS NOT INITIAL
      AND <li_xnast_e351> IS ASSIGNED.
        <li_xnast_e351> =  xnast_e351[].
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
