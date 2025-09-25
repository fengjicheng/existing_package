*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVOICE_BLOCK
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925509
* REFERENCE NO:  OTCM-53244
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:  01/04/2022
* PROGRAM NAME: ZQTCN_INVOICE_BLOCK (Include)
*              called from ZXVVAU05.
* DESCRIPTION: Auto activation of Delivery and Billing block to prevent invoicing
*              without payment being processed.
*------------------------------------------------------------------------- *
CONSTANTS: lc_dev_e350  TYPE zdevid VALUE 'E350',
           lc_p_aust3   TYPE rvari_vnam VALUE 'AUST3', "Payment cards: Overall status
           lc_p_auart   TYPE rvari_vnam VALUE 'AUART', "Sales document type
           lc_p_zlsch   TYPE rvari_vnam VALUE 'ZLSCH', "Payment Method
           lc_p_fpart   TYPE rvari_vnam VALUE 'FPART', "Billing plan type
           lc_p_lifsk   TYPE rvari_vnam VALUE 'LIFSK', "Delivery Block
           lc_p_faksk   TYPE rvari_vnam VALUE 'FAKSK', "Billing Block
           lc_aust3     TYPE aust3_cc   VALUE 'A',
           lc_p_crmode  TYPE rvari_vnam VALUE 'CREATE', "Create Mode
           lc_p_chmode  TYPE rvari_vnam  VALUE 'CHANGE', "Change Mode
           lc_ord       TYPE vbtyp VALUE 'C',
           lc_cont      TYPE vbtyp VALUE 'G',
           lc_hd        TYPE posnr VALUE '000000',
           lc_ordcrepro TYPE sy-repid VALUE 'SAPMV45A'.

DATA: li_consnt TYPE zcat_constants,
      lv_flg(1) TYPE c,
      lv_create TYPE c,
      lv_change TYPE c.

STATICS: lr_aust3_i TYPE RANGE OF fpla-aust3,
         lr_auart_i TYPE RANGE OF vbak-auart,
         lr_zlsch_i TYPE RANGE OF vbkd-zlsch,
         lr_fpart_i TYPE RANGE OF fpla-fpart,
         lr_lifsk_i TYPE RANGE OF vbak-lifsk,
         lr_faksk_i TYPE RANGE OF vbak-faksk,
         lv_auart   TYPE auart.

REFRESH:  li_consnt.

lv_auart = lst_vbak5-auart. "Sales Document Type

*  Fetch data from constant table.
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_dev_e350   "Development ID
  IMPORTING
    ex_constants = li_consnt. "Constant Values

REFRESH: lr_aust3_i,lr_auart_i, lr_zlsch_i, lr_fpart_i, lr_lifsk_i, lr_faksk_i.

*------------------- Fetch constant table entries --------------*
LOOP AT li_consnt ASSIGNING FIELD-SYMBOL(<lst_consnt>).
  CASE <lst_consnt>-param1.
    WHEN lc_p_aust3.
      APPEND INITIAL LINE TO lr_aust3_i ASSIGNING FIELD-SYMBOL(<lst_aust3_i>).
      <lst_aust3_i>-sign   = <lst_consnt>-sign.
      <lst_aust3_i>-option = <lst_consnt>-opti.
      <lst_aust3_i>-low    = <lst_consnt>-low.
      <lst_aust3_i>-high   = <lst_consnt>-high.
    WHEN lc_p_auart.
      APPEND INITIAL LINE TO lr_auart_i ASSIGNING FIELD-SYMBOL(<lst_auart_i>).
      <lst_auart_i>-sign   = <lst_consnt>-sign.
      <lst_auart_i>-option = <lst_consnt>-opti.
      <lst_auart_i>-low    = <lst_consnt>-low.
      <lst_auart_i>-high   = <lst_consnt>-high.
    WHEN lc_p_zlsch.
      APPEND INITIAL LINE TO lr_zlsch_i ASSIGNING FIELD-SYMBOL(<lst_zlsch_i>).
      <lst_zlsch_i>-sign   = <lst_consnt>-sign.
      <lst_zlsch_i>-option = <lst_consnt>-opti.
      <lst_zlsch_i>-low    = <lst_consnt>-low.
      <lst_zlsch_i>-high   = <lst_consnt>-high.
    WHEN lc_p_fpart.
      APPEND INITIAL LINE TO lr_fpart_i ASSIGNING FIELD-SYMBOL(<lst_fpart_i>).
      <lst_fpart_i>-sign   = <lst_consnt>-sign.
      <lst_fpart_i>-option = <lst_consnt>-opti.
      <lst_fpart_i>-low    = <lst_consnt>-low.
      <lst_fpart_i>-high   = <lst_consnt>-high.
    WHEN lc_p_lifsk.
      APPEND INITIAL LINE TO lr_lifsk_i ASSIGNING FIELD-SYMBOL(<lst_lifsk_i>).
      <lst_lifsk_i>-sign   = <lst_consnt>-sign.
      <lst_lifsk_i>-option = <lst_consnt>-opti.
      <lst_lifsk_i>-low    = <lst_consnt>-low.
      <lst_lifsk_i>-high   = <lst_consnt>-high.
    WHEN lc_p_faksk.
      APPEND INITIAL LINE TO lr_faksk_i ASSIGNING FIELD-SYMBOL(<lst_faksk_i>).
      <lst_faksk_i>-sign   = <lst_consnt>-sign.
      <lst_faksk_i>-option = <lst_consnt>-opti.
      <lst_faksk_i>-low    = <lst_consnt>-low.
      <lst_faksk_i>-high   = <lst_consnt>-high.
    WHEN lc_p_crmode.
      lv_create = <lst_consnt>-low.
    WHEN lc_p_chmode.
      lv_change = <lst_consnt>-low.
  ENDCASE.
ENDLOOP.
"This is to control enhancement for create or changes mode from constant table.
IF <lfs_t180_2>-trtyp = lv_create OR <lfs_t180_2>-trtyp = lv_change.
  IF  lv_auart IN lr_auart_i.
    IF sy-batch IS INITIAL "AND sy-binpt IS INITIAL
          AND sy-cprog = lc_ordcrepro. "Only fore ground changes

      DATA: li_fplnr TYPE RANGE OF fplnr,
            lv_fplnr LIKE LINE OF li_fplnr.

      DATA(xvbkd2) = xvbkd5[].
      IF lst_vbak5-vbtyp = lc_cont.  "Check for Contract
        DELETE  xvbkd2 WHERE fplnr IS NOT INITIAL.
      ELSEIF lst_vbak5-vbtyp = lc_ord.  "Check for Order
        DELETE  xvbkd2 WHERE posnr NE lc_hd.
        lv_flg = abap_true.
      ENDIF.
      READ TABLE xvbkd2 INTO DATA(lw_xvbkd) INDEX 1.
      IF sy-subrc = 0.
        IF lw_xvbkd-zlsch IN lr_zlsch_i.  "Check for Payment Methd
*---------Reading billing plan details to check the payment card details overall status--------*
          LOOP AT xfpla5 INTO DATA(lw_xfpla).
            READ TABLE xvbkd5 INTO DATA(lw_xvbkd2) WITH KEY fplnr = lw_xfpla-fplnr.
            IF sy-subrc NE 0.
"Checking Billing plan type and Payment card overall status details if matches then
" billing block and delivery block will be assigned other wise it will be blank.
              IF  lw_xfpla-fpart IN lr_fpart_i.
                IF lw_xfpla-aust3 IN lr_aust3_i.
"BOC by MRAJKUMAR OTCM-53244-ED2K927486-01-June-2022
                  IF  lst_vbak5-lifsk IS INITIAL
                  AND lst_vbak5-faksk IS INITIAL.
"EOC by MRAJKUMAR OTCM-53244-ED2K927486-01-June-2022
                    lst_vbak5-lifsk =  <lst_lifsk_i>-low.
                    lst_vbak5-faksk =  <lst_faksk_i>-low.
                    EXIT.
                  ENDIF.""BOC by MRAJKUMAR OTCM-53244-ED2K927486-01-June-2022
                ELSEIF ( lw_xfpla-aust3 = lc_aust3
                OR       lw_xfpla-aust3  IS INITIAL ).
"BOC by MRAJKUMAR OTCM-53244-ED2K927486-01-June-2022
                  IF   lst_vbak5-lifsk IN lr_lifsk_i
                  AND  lst_vbak5-faksk IN lr_faksk_i.
"EOC by MRAJKUMAR OTCM-53244-ED2K927486-01-June-2022
                     CLEAR: lst_vbak5-lifsk, lst_vbak5-faksk.
                  ENDIF.""BOC by MRAJKUMAR OTCM-53244-ED2K927486-01-June-2022
                ENDIF.
              ENDIF.
            ENDIF.
            CLEAR lw_xfpla.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
