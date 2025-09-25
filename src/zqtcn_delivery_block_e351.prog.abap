*&---------------------------------------------------------------------*
*& Report  ZQTCN_DELIVERY_BLOCK_E351
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DELIVERY_BLOCK_E351                              *
* PROGRAM DESCRIPTION: This include will add the DD delivery block for *
*       orders created with sales org 3310 and Payment method U or J   *
*      and order type ZSUB or ZREW                                     *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 02/09/2022                                          *
* OBJECT ID      : E351                                                *
* TRANSPORT NUMBER(S): ED2K925685                                      *
*----------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

DATA: lt_const  TYPE  zcat_constants,
      lr_auart  TYPE TABLE OF tds_rg_auart,
      lr_vkorg  TYPE TABLE OF range_vkorg,
      lr_zlsch  TYPE TABLE OF trty_rng_zlsch.

CONSTANTS: lc_create TYPE c VALUE 'H'.

CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = 'E351'
  IMPORTING
    ex_constants = lt_const.

LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
  CASE <lfs_const>-param1.
    WHEN 'AUART'.
      APPEND INITIAL LINE TO lr_auart ASSIGNING FIELD-SYMBOL(<lfs_auart_i>).
      <lfs_auart_i>-sign = <lfs_const>-sign.
      <lfs_auart_i>-option = <lfs_const>-opti.
      <lfs_auart_i>-low = <lfs_const>-low.
      <lfs_auart_i>-high = <lfs_const>-high.
    WHEN 'VKORG'.
      APPEND INITIAL LINE TO lr_vkorg ASSIGNING FIELD-SYMBOL(<lfs_vkorg_i>).
      <lfs_vkorg_i>-sign = <lfs_const>-sign.
      <lfs_vkorg_i>-option = <lfs_const>-opti.
      <lfs_vkorg_i>-low = <lfs_const>-low.
      <lfs_vkorg_i>-high = <lfs_const>-high.
    WHEN 'LIFSK'.
      DATA(lv_lifsk) =  <lfs_const>-low.
    WHEN 'ZLSCH'.
      APPEND INITIAL LINE TO lr_zlsch ASSIGNING FIELD-SYMBOL(<lfs_zlsch_i>).
      <lfs_zlsch_i>-sign = <lfs_const>-sign.
      <lfs_zlsch_i>-option = <lfs_const>-opti.
      <lfs_zlsch_i>-low = <lfs_const>-low.
      <lfs_zlsch_i>-high = <lfs_const>-high.
    WHEN OTHERS.
      "Do nothing.
  ENDCASE.
  CLEAR: <lfs_const>.
ENDLOOP.

IF  <lfs_t180_2>-trtyp = lc_create
AND xvbak-auart IN lr_auart
AND xvbak-vkorg IN lr_vkorg.
  READ TABLE xvbkd[] INTO DATA(lst_xvbkd) INDEX 1.
    IF  sy-subrc IS INITIAL
    AND lst_xvbkd-zlsch IN lr_zlsch.
      lst_vbak_351-lifsk =  lv_lifsk.
    ENDIF.
ENDIF.
